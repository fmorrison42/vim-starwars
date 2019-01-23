let s:file = expand('<sfile>:h:h') . '/resources/sw1.txt'
function! s:play() abort
  echomsg 'Loading...'
  let l:height = 13
  let l:frames = []
  let l:lines = readfile(s:file)
  for l:i in range(len(l:lines))
    if l:i%(l:height+1) == 0
      let l:duration = 0 + l:lines[i]
      call add(l:frames, {'lines': l:lines[l:i+1 : i+l:height], 'duration': l:duration})
    endif
  endfor
  unlet l:lines
  redraw
  echo ''
  new | only! | setlocal buftype=nofile bufhidden=wipe
  let l:speed = 15
  for l:frame in l:frames
    call setline(1, l:frame['lines'])
    let l:duration = max([l:frame['duration'] * 1000 / l:speed, 1])
    exe printf('sleep %dms', l:duration)
    redraw!
    let l:key = getchar(0)
    if l:key == 106
      if l:speed > 1
        let l:speed += 1
      endif
    elseif l:key == 107
      let l:speed -= 1
    elseif l:key != 0
      break
    endif
  endfor
  bw!
endfunction

command -nargs=0 StarWars call s:play()
