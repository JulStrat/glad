program glfw_triangle;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

{$APPTYPE Console}

uses
  SysUtils,
  glad_gl, Neslib.Glfw3;

procedure ErrorCallback(error: Integer; const description: PAnsiChar); cdecl;
var
  desc: String;
begin
  desc := String(AnsiString(description));
  raise Exception.CreateFmt('GLFW Error %d: %s', [error, Desc]);
end;

procedure KeyCallback(window: PGLFWwindow; key, scancode, action, mods: Integer); cdecl;
begin
  if (key = GLFW_KEY_ESCAPE) and (action = GLFW_PRESS) then
    glfwSetWindowShouldClose(window, GLFW_TRUE);
end;

procedure Run;
var
  window: PGLFWwindow;
  ratio: Single;
  width, height: Integer;

begin
  glfwSetErrorCallback(ErrorCallback);
  if (glfwInit = 0) then
    raise Exception.Create('Unable to initialize GLFW');

  window := glfwCreateWindow(640, 480, glfwGetVersionString(), nil, nil);
  if (window = nil) then
  begin
    glfwTerminate;
    raise Exception.Create('Unable to create GLFW window');
  end;

  glfwMakeContextCurrent(window);
  if not gladLoadGL(@glfwGetProcAddress) then
  begin
    WriteLn('Failed to load GL');
    glfwTerminate();
    Halt(1);
  end;

  glfwSwapInterval(1);
  glfwSetKeyCallback(window, KeyCallback);

  while (glfwWindowShouldClose(window) = 0) do
  begin
    glfwGetFramebufferSize(window, @width, @height);
    ratio := width / height;
    glViewport(0, 0, width, height);
    glClear(GL_COLOR_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glRotatef(glfwGetTime() * 50.0, 0.0, 0.0, 1.0);
    glBegin(GL_TRIANGLES);
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(-0.6, -0.4, 0.0);
    glColor3f(0.0, 1.0, 0.0);
    glVertex3f(0.6, -0.4, 0.0);
    glColor3f(0.0, 0.0, 1.0);
    glVertex3f(0.0, 0.6, 0.0);
    glEnd();
    glfwSwapBuffers(window);
    glfwPollEvents();
  end;

  glfwDestroyWindow(window);
  glfwTerminate;
end;

begin
  Run;
end.
