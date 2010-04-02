function runQueueIn(count) {
  window.setTimeout("queue.process()", count);
}

function updateProjectBoxWithFade(project) {
  box = $('#'+project.name+' a');
  if (box.size() == 0) {
    document.location.reload(true);
  }
  newbox = box.clone();
  newbox.removeClass();
  // project specific stuff
  newbox.addClass(project.status);
  if (project.status == 'building') {
    newbox.find('img').attr('src', '#{path_root}/images/loading.gif');
  }
  else {
    newbox.find('img').attr('src', project.author_gravatar);
  }
  // animation stuff
  newbox.css('position', 'absolute');
  newbox.hide();
  newbox.appendTo(box.parent());
  newbox.fadeIn(2000, function(){
    newbox.css('position', 'static');
    box.remove();
    queue.schedule(500);
  });
  box.fadeOut(2000);
};

queue = new Queue(updateProjectBoxWithFade, runQueueIn);

$(document).ready(function(){
  ws = new WebSocket("ws://#{request.host}:8080/");
  ws.onmessage = function(evt) { 
    project = JSON.parse(evt.data);
    queue.push(project);
  }

  ws.onclose = function() { 
    window.setTimeout('window.location.reload(true)', 10000);
    $('.server-closed').show();
  };

  ws.onopen = function() { };

  queue.schedule(1000);
});