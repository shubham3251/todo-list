%%raw(`import './App.css';`)
@module("./logo.svg") external logo: string = "default"

type todo = {
  title: string,
  isDone: bool,
}

type state = {todoList: array<todo>, inputValue: string}

let initialState = {
  todoList: [],
  inputValue: "",
}

type action = AddTodo | ClearTodos | InputChanged(string) | CheckInput(int)

let reducer = (state: state, action: action) => {
  switch action {
  | AddTodo => {
      inputValue: "",
      todoList: Array.append(state.todoList, [{title: state.inputValue, isDone: false}]),
    }
  | ClearTodos => {
      ...state,
      todoList: [],
    }
  | InputChanged(value) => {
      ...state,
      inputValue: value,
    }
  | CheckInput(index) => {
      ...state,
      todoList: Belt.Array.mapWithIndex(state.todoList, (i, todo) => {
        if i == index {
          {
            ...todo,
            isDone: !todo.isDone,
          }
        } else {
          todo
        }
      }),
    }
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  let onChangeInput = (e: ReactEvent.Form.t) => {
    let newValue = ReactEvent.Form.target(e)["value"]
    dispatch(InputChanged(newValue))
  }

  let onCheckboxToggle = (e: ReactEvent.Form.t, i: int) => {
    dispatch(CheckInput(i))
  }

  <div className="App">
    <h1> {"Todo List"->React.string} </h1>
    <div>
      <input type_="text" value=state.inputValue onChange=onChangeInput />
      <button onClick={_ => dispatch(AddTodo)}> {"Submit"->React.string} </button>
    </div>
    {Belt.Array.mapWithIndex(state.todoList, (i, todo) =>
      <div key={Belt.Int.toString(i)}>
        <input type_="checkbox" onChange={e => onCheckboxToggle(e, i)} />
        <span className={todo.isDone ? "todoChecked" : ""}> {todo.title->React.string} </span>
      </div>
    )->React.array}
  </div>
}
