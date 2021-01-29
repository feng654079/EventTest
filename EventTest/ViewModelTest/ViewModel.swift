
import Foundation


enum EventState {
    case doing
    case success
    case fail(msg:String)
}

protocol SendEventable{
    
    associatedtype EventType
    associatedtype Handler = (_ eType:EventType,_ eState:EventState) -> Void
    
    init(eventHandler: Handler)
    func send(_ eventType:EventType,_ eventState:EventState)
 
}


class ViewModel<T> :SendEventable  {
  
    typealias EventType = T
    
    let _eventHanlder: Handler
    required init(eventHandler: @escaping (EventType, EventState) -> Void) {
        self._eventHanlder = eventHandler
    }
    
    func send(_ eventType:EventType,_ eventState:EventState) {
        self._eventHanlder(eventType,eventState)
    }
}



//MARK:-

class LoginViewModel: ViewModel<LoginViewModel.EventType> {
    enum EventType {
        case login
        case validationUserName
        case validationPwd
    }

    var inUserName:String = ""
    var inPwd:String = ""
    

    func triggerLogin() {
        
        if inUserName.isEmpty {
            send(.validationUserName, .fail(msg: "用户名为空"))
            return
        }
        
        if inPwd.isEmpty {
            send(.validationPwd, .fail(msg: "密码为空"))
            return
        }
        
        debugPrint("调用登录接口,成功了")
        send(.login, .success)
    }
    
}


class SearchViewModel: ViewModel<SearchViewModel.EventType> {
    enum EventType {
        case searchGoods
    }
    
    /// 输入输出对儿
    /// 可能只有输入,那种情况对应不关心返回值的情况
    
    var inSearchKey: String = ""
    private(set) var searchResult = [String]()
    
    func triggerSearch() {
        if inSearchKey.isEmpty {
            send(.searchGoods, .fail(msg: "搜索关键词为空"))
            return
        }
        
        debugPrint("调用搜索接口,成功后")
        send(.searchGoods, .success)
    }
}

class HomeViewModel: ViewModel<HomeViewModel.EventType> {
    enum EventType {
        case fetchTodayQuotation
        case fetchHotInfo
    }
    
    //MARK:今日行情
    private(set) var outTodayQuotation = [Any]()
    
    func triggerFetchTodayQuotation() {
           
        send(.fetchTodayQuotation, .success)
    }
    
    
    //MARK:热门资讯
    private(set) var outHotInfo = [Any]()
    
    func triggerFetchHotInfo() {
        send(.fetchHotInfo, .success)
    }
}

class GoodsListViewModel:ViewModel<GoodsListViewModel.EventType> {
    enum EventType {
        case fetchGoodsList(loadMore:Bool)
    }
    
    
    func triggerFetchGoodsList(loadMore:Bool) {
        
        send(.fetchGoodsList(loadMore: loadMore), .success)
    }
    
}



fileprivate func test() {
   let vm =  SearchViewModel { (type, state) in
        switch type {
        
        case .searchGoods:
            uihandleSearchEvent(state: state)
        }
    }
    
    /// some times
    vm.triggerSearch()
}

fileprivate func uihandleSearchEvent(state:EventState) {
    switch state {
    
    case .doing:
        debugPrint("正在搜索UI")
    case .success:
        debugPrint("搜索成功UI")
    case .fail(msg: let msg):
        debugPrint("搜索错误UI:\(msg)")
    }
}


