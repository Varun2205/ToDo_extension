const input = document.getElementById("taskInput");
const list = document.getElementById("taskList");

input.focus();

function saveTasks() {
  const tasks = [];
  document.querySelectorAll("li").forEach(li => {
    tasks.push({
      text: li.querySelector(".text").textContent,
      done: li.classList.contains("completed")
    });
  });
  localStorage.setItem("tasks", JSON.stringify(tasks));
}

function loadTasks() {
  const tasks = JSON.parse(localStorage.getItem("tasks") || "[]");
  // Filter out completed tasks - only load incomplete ones
  const incompleteTasks = tasks.filter(task => !task.done);
  
  // Clear existing list (in case there are any)
  list.innerHTML = '';
  
  // Only add incomplete tasks
  incompleteTasks.forEach(task => addTask(task.text, false));
}

function addTask(text, done = false) {
  const li = document.createElement("li");

  const check = document.createElement("div");
  check.className = "check";

  const span = document.createElement("span");
  span.className = "text";
  span.textContent = text;

  check.onclick = () => {
    li.classList.toggle("completed");
    saveTasks();
  };

  li.appendChild(check);
  li.appendChild(span);

  if (done) li.classList.add("completed");

  list.appendChild(li);
}

input.addEventListener("keydown", e => {
  if (e.key === "Enter" && input.value.trim()) {
    addTask(input.value.trim());
    input.value = "";
    saveTasks();
  }
});

const shortcuts = [
  "gmail",
  "netflix",
  "primevideo",
  "himanime",
  "amazon",
  "udemy",
  "flixhq",
];


const shortcutIcons = {
  gmail: "mail",
  netflix: "movie",
  primevideo: "ondemand_video",
  himanime: "play_circle",
  amazon: "shopping_cart",
  udemy: "school",
  flixhq: "theaters",
};

const shortcutLinks = {
  gmail: "https://mail.google.com",
  netflix: "https://www.netflix.com",
  primevideo: "https://www.primevideo.com",
  himanime: "https://hianime.sx",
  amazon: "https://www.amazon.in",
  udemy: "https://www.udemy.com",
  flixhq: "https://flixhq.tube/"
};


function makeSt() {
  const stCont = document.getElementsByClassName("shortcuts")[0];

  shortcuts.forEach((st) => {
    const mainEle = document.createElement("div");
    mainEle.className = `shortcut ${st}`;

    const icon = document.createElement("span");
    icon.className = "material-symbols-outlined";
    icon.textContent = shortcutIcons[st];

    mainEle.addEventListener("click", () => {
      window.location.href = shortcutLinks[st];
    });

    mainEle.appendChild(icon);
    stCont.appendChild(mainEle);
  });
mainEle.onclick = () => {
  window.open(shortcutLinks[st], "_blank");
};
}






loadTasks();
makeSt();