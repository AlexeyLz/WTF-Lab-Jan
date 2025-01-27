import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../create_page/icons.dart';
import '../data/database_provider.dart';
import '../event.dart';
import '../note.dart';
import '../theme/theme.dart';
import 'cubit_event_page.dart';
import 'states_event_page.dart';

class EventPage extends StatefulWidget {
  final String title;
  final Note note;
  final List<Note> noteList;

  EventPage({Key key, this.title, this.note, this.noteList}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note, noteList);
}

class _EventPageState extends State<EventPage> {
  final Note _note;
  final List<Note> noteList;
  final TextEditingController textController = TextEditingController();
  TextEditingController textSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  CubitEventPage _cubit;
  DatabaseProvider databaseProvider = DatabaseProvider();

  @override
  void initState() {
    _focusNode.requestFocus();
    _cubit.initEventList();
    super.initState();
  }

  _EventPageState(this._note, this.noteList) {
    _cubit = CubitEventPage(StatesEventPage(_note));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: state.isSearch ? searchAppBar : _defaultAppBar(state),
          body: _eventPageBody(state),
        );
      },
    );
  }

  TextField get _textFieldSearch {
    return TextField(
      controller: textSearchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Enter text',
        border: InputBorder.none,
        filled: true,
      ),
    );
  }

  AppBar get searchAppBar {
    return AppBar(
      title: _textFieldSearch,
      actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              textSearchController.clear();
              _cubit.setTextSearch(false);
            },
          ),
        ),
      ],
    );
  }

  AppBar _defaultAppBar(StatesEventPage state) {
    return AppBar(
      title: Center(
        child: Text(widget.title),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _searchFocusNode.requestFocus();
            _cubit.setTextSearch(
              !_cubit.state.isSearch,
            );
            textSearchController.addListener(
              () {
                _cubit.setEventsList(state.eventList);
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _eventPageBody(StatesEventPage state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _listView(state),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black26,
              ),
            ),
          ),
          child: _textFieldArea,
        ),
      ],
    );
  }

  Row get _textFieldArea {
    return Row(
      children: <Widget>[
        IconButton(
          icon: _cubit.state.indexOfSelectedCircleAvatar == null
              ? CircleAvatar(
                  child: Icon(Icons.category),
                )
              : CircleAvatar(
                  child: listIcons[_cubit.state.indexOfSelectedCircleAvatar],
                ),
          iconSize: 32,
          onPressed: () => _showBottomSheetIcons(context),
        ),
        Expanded(
          child: TextField(
            controller: textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Enter event',
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          iconSize: 32,
          color: Colors.blueGrey,
          onPressed: () {
            if (_cubit.state.isEditing) {
              _cubit.editText(_cubit.state.selectedElement, textController,
                  _cubit.state.indexOfSelectedCircleAvatar);
            } else {
              _cubit.sendEvent(textController);
              _cubit.removeSelectedCircleAvatar();
            }
          },
        ),
      ],
    );
  }

  ListView _listView(StatesEventPage state) {
    final _myEventList = state.isSearch
        ? state.eventList
            .where(
                (element) => element.text.contains(textSearchController.text))
            .toList()
        : state.eventList;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _myEventList.length,
      itemBuilder: (context, index) {
        return _showEventList(_myEventList[index], index);
      },
    );
  }

  Widget _showEventList(Event event, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 5,
          color: ThemeSwitcher.of(context).color,
          child: ListTile(
            leading: event.indexOfCircleAvatar != null
                ? CircleAvatar(
                    child: listIcons[event.indexOfCircleAvatar],
                  )
                : null,
            title: Text(event.text),
            subtitle: Align(
              alignment: Alignment.bottomRight,
              child: Text(event.time),
            ),
            onLongPress: () {
              _cubit.setIndexOfSelectedElement(event);
              _showBottomSheet(context, event, index);
            },
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Event event, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 280,
          child: _buildBottomNavigationMenu(index, event),
        );
      },
    );
  }

  void _showBottomSheetIcons(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 70,
          child: Row(
            children: [
              IconButton(
                icon: CircleAvatar(
                  child: Icon(Icons.clear),
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  _cubit.removeSelectedCircleAvatar();
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listIcons.length,
                  itemBuilder: (context, index) => _iconButton(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconButton _iconButton(var index) {
    return IconButton(
      icon: CircleAvatar(
        child: listIcons[index],
      ),
      onPressed: () {
        _cubit.setIndexOfSelectedCircleAvatar(index);
        Navigator.pop(context);
      },
    );
  }

  Column _buildBottomNavigationMenu(int index, Event event) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: Text('Edit'),
          onTap: () {
            _cubit.editEvent(event, textController);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.reply,
            color: Colors.grey,
          ),
          title: Text('Send'),
          onTap: () {
            Navigator.pop(context);
            _showRadioList(index, event);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.copy,
            color: Colors.orange,
          ),
          title: Text('Copy'),
          onTap: () {
            _copyEvent(index);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.green,
          ),
          title: Text('Important'),
          onTap: () {
            _importantEvent(index);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          title: Text('Delete'),
          onTap: () {
            _cubit.deleteEvent(event);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showRadioList(int index, Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder(
          cubit: _cubit,
          builder: (context, state) {
            return AlertDialog(
              title: Text('Choose the page'),
              content: _dialogColumn(index),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _cubit.transferEvent(event, noteList);
                    _cubit.deleteEvent(event);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Padding _dialogColumn(var index) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          return RadioListTile(
            title: Text(noteList[index].eventName),
            value: index,
            activeColor: Theme.of(context).accentColor,
            groupValue: _cubit.state.selectedIndex,
            onChanged: (value) => _cubit.setSelectedIndex(value),
          );
        },
      ),
    );
  }

  void _importantEvent(int index) {
    _note.subTittleEvent = _cubit.state.eventList[index].text;
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _cubit.state.eventList[index].text));
  }
}
