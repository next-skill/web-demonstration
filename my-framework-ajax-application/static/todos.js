async function loadTodos() {
  response = await fetch('/api/todos')
  responseBody = await response.json()

  console.log('[responseBody]')
  console.log(responseBody)

  // DOM を操作して動的に HTML を変更
  trElements = responseBody.todos.map(todo => {
    return `
      <tr>
        <td>${todo.id}</td>
        <td>${todo.title}</td>
      </tr>
    `
  }).reduce((l, r) => l + r, '')

  todosTableBody = document.getElementById('todos-table-body')
  todosTableBody.innerHTML = trElements
}

async function registerTodo() {
  title = document.getElementById('todo-post-title').value

  await fetch('/api/todos', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      title: title
    })
  })

  await loadTodos()
}

loadTodos()
