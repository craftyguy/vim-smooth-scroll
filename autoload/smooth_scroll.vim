" ==============================================================================
" File: smooth_scroll.vim
" Author: Terry Ma
" Description: Scroll the screen smoothly to retain better context. Useful for
" replacing Vim's default scrolling behavior with CTRL-D, CTRL-U, CTRL-B, and
" CTRL-F
" Last Modified: April 04, 2013
" ==============================================================================

let s:save_cpo = &cpo
set cpo&vim

" ==============================================================================
" Global Functions
" ==============================================================================

" Scroll the screen up
function! smooth_scroll#up(dist, duration, speed, follow) range
  call s:smooth_scroll('u', a:dist, a:duration, a:speed, a:follow, v:count1)
endfunction

" Scroll the screen down
function! smooth_scroll#down(dist, duration, speed, follow) range
  call s:smooth_scroll('d', a:dist, a:duration, a:speed, a:follow, v:count1)
endfunction

" ==============================================================================
" Functions
" ==============================================================================

" Scroll the scroll smoothly
" dir: Direction of the scroll. 'd' is downwards, 'u' is upwards
" dist: Distance, or the total number of lines to scroll
" duration: How long should each scrolling animation last. Each scrolling
" animation will take at least this long. It could take longer if the scrolling
" itself by Vim takes longer
" speed: Scrolling speed, or the number of lines to scroll during each scrolling
" animation
" follow: Coursor follows scrolling line or not. 1 is follow, 0 is not
function! s:smooth_scroll(dir, dist, duration, speed, follow, repeat)
  let last_line_number = line('$')
  let dist = a:dist + (a:dist * a:repeat)
  for i in range(dist/a:speed)
    let start = reltime()
    let current_line = line('.')
    let current_window_line = winline()
    if a:dir ==# 'd'
      let at_bottom = current_window_line == 1 && current_line == last_line_number
      if at_bottom
        break
      endif
      if a:follow == 0
        exec "normal! ".a:speed."\<C-e>".a:speed."j"
      else
        exec "normal! ".a:speed."\<C-e>"
      endif
    else
      let at_top = current_window_line == 1 && current_line == 1
      if at_top
        break
      endif
      if a:follow == 0
        exec "normal! ".a:speed."\<C-y>".a:speed."k"
      else
        exec "normal! ".a:speed."\<C-y>"
      endif
    endif
    redraw
    let elapsed = s:get_ms_since(start)
    let snooze = float2nr(a:duration-elapsed)
    if snooze > 0
      exec "sleep ".snooze."m"
    endif
  endfor
endfunction

function! s:get_ms_since(time)
  let cost = split(reltimestr(reltime(a:time)), '\.')
  return str2nr(cost[0])*1000 + str2nr(cost[1])/1000
endfunction


