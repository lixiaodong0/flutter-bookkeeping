import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:bookkeeping/data/repository/account_book_repository.dart';
import 'package:bookkeeping/widget/toast_action_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AccountBookRepository accountBookRepository;

  AppBloc({required this.accountBookRepository}) : super(AppState()) {
    on<AppInitLoad>(_onInitLoad);
    on<AppUpdateCurrentAccountBook>(_onUpdateCurrentAccountBook);
    on<AppUpdateAccountBook>(_onUpdateAccountBook);
    on<AppUpdateAllAccountBook>(_onUpdateAllAccountBook);
    on<AppCreateNewAccountBook>(_onCreateNewAccountBook);
    on<AppDeleteAccountBook>(_onDeleteAccountBook);
  }

  //初始化
  void _onInitLoad(AppInitLoad event, Emitter<AppState> emit) async {
    var allAccountBooks = await accountBookRepository.findAll();
    var currentAccountBook = _findCurrentAccountBook(allAccountBooks);
    emit(
      state.copyWith(
        currentAccountBook: currentAccountBook,
        allAccountBooks: allAccountBooks,
      ),
    );
  }

  //创建新的账本
  void _onCreateNewAccountBook(
    AppCreateNewAccountBook event,
    Emitter<AppState> emit,
  ) async {
    List<AccountBookBean> allAccountBooks = [];
    allAccountBooks.addAll(state.allAccountBooks);
    allAccountBooks.insert(0, event.accountBook);
    emit(state.copyWith(allAccountBooks: allAccountBooks));
  }

  //更新所有的账本
  void _onUpdateAllAccountBook(
    AppUpdateAllAccountBook event,
    Emitter<AppState> emit,
  ) async {
    var allAccountBooks = await accountBookRepository.findAll();
    emit(state.copyWith(allAccountBooks: allAccountBooks));
  }

  //更新账本
  void _onUpdateAccountBook(
    AppUpdateAccountBook event,
    Emitter<AppState> emit,
  ) async {
    var newAccountBook = event.accountBook;
    List<AccountBookBean> allAccountBooks = [];
    allAccountBooks.addAll(state.allAccountBooks);
    var findIndex = allAccountBooks.indexWhere(
      (element) => element.id == newAccountBook.id,
    );
    allAccountBooks[findIndex] = newAccountBook;

    if (newAccountBook.id == state.currentAccountBook?.id) {
      emit(
        state.copyWith(
          currentAccountBook: newAccountBook,
          allAccountBooks: allAccountBooks,
        ),
      );
    } else {
      emit(state.copyWith(allAccountBooks: allAccountBooks));
    }
  }

  //删除账本
  void _onDeleteAccountBook(
    AppDeleteAccountBook event,
    Emitter<AppState> emit,
  ) async {
    var deleteAccountBook = event.accountBook;
    List<AccountBookBean> allAccountBooks = [];
    allAccountBooks.addAll(state.allAccountBooks);
    var findIndex = allAccountBooks.indexWhere(
      (element) => element.id == deleteAccountBook.id,
    );
    allAccountBooks.removeAt(findIndex);
    emit(state.copyWith(allAccountBooks: allAccountBooks));

    //当前正在显示的账本被删除，默认选中系统的。
    if (deleteAccountBook.id == state.currentAccountBook?.id) {
      var findIndex = allAccountBooks.indexWhere(
        (element) => element.sysDefault == 1,
      );
      var newCurrentAccountBook = allAccountBooks[findIndex];
      //延迟1秒再执行切换操作
      await Future.delayed(Duration(seconds: 1));
      await startUpdateCurrentAccountBook(newCurrentAccountBook, emit);
    }
  }

  AccountBookBean _findCurrentAccountBook(
    List<AccountBookBean> allAccountBooks,
  ) {
    return allAccountBooks.singleWhere((element) => element.show == 1);
  }

  //更新当前账本
  void _onUpdateCurrentAccountBook(
    AppUpdateCurrentAccountBook event,
    Emitter<AppState> emit,
  ) async {
    var newCurrentAccountBook = event.currentAccountBook;
    await startUpdateCurrentAccountBook(newCurrentAccountBook, emit);
  }

  Future<void> startUpdateCurrentAccountBook(
    AccountBookBean newCurrentAccountBook,
    Emitter<AppState> emit,
  ) async {
    if (newCurrentAccountBook.id == state.currentAccountBook?.id) {
      return;
    }
    showSuccessActionToast("已切换到${newCurrentAccountBook.name}");

    await accountBookRepository.setCurrentShowId(newCurrentAccountBook.id);

    List<AccountBookBean> allAccountBooks = [];
    allAccountBooks.addAll(state.allAccountBooks);
    for (var item in allAccountBooks) {
      item.show = 0;
    }
    var findIndex = allAccountBooks.indexWhere(
      (element) => element.id == newCurrentAccountBook.id,
    );
    if (findIndex != -1) {
      allAccountBooks[findIndex].show = 1;
      newCurrentAccountBook = allAccountBooks[findIndex];
    } else {
      newCurrentAccountBook.show = 1;
      allAccountBooks.insert(0, newCurrentAccountBook);
    }
    emit(
      state.copyWith(
        currentAccountBook: newCurrentAccountBook,
        allAccountBooks: allAccountBooks,
      ),
    );
  }
}

final class AppState extends Equatable {
  final AccountBookBean? currentAccountBook;
  final List<AccountBookBean> allAccountBooks;

  const AppState({this.currentAccountBook, this.allAccountBooks = const []});

  @override
  List<Object?> get props => [currentAccountBook, allAccountBooks];

  AppState copyWith({
    AccountBookBean? currentAccountBook,
    List<AccountBookBean>? allAccountBooks,
  }) {
    return AppState(
      currentAccountBook: currentAccountBook ?? this.currentAccountBook,
      allAccountBooks: allAccountBooks ?? this.allAccountBooks,
    );
  }
}

class AppEvent {
  const AppEvent();
}

class AppInitLoad extends AppEvent {
  const AppInitLoad();
}

class AppUpdateAllAccountBook extends AppEvent {
  const AppUpdateAllAccountBook();
}

class AppCreateNewAccountBook extends AppEvent {
  final AccountBookBean accountBook;

  const AppCreateNewAccountBook(this.accountBook);
}

class AppUpdateAccountBook extends AppEvent {
  final AccountBookBean accountBook;

  const AppUpdateAccountBook(this.accountBook);
}

class AppDeleteAccountBook extends AppEvent {
  final AccountBookBean accountBook;

  const AppDeleteAccountBook(this.accountBook);
}

class AppUpdateCurrentAccountBook extends AppEvent {
  final AccountBookBean currentAccountBook;

  const AppUpdateCurrentAccountBook(this.currentAccountBook);
}
