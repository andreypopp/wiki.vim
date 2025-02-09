" A simple wiki plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
" License:    MIT license
"

if exists('g:wiki_loaded') | finish | endif
let g:wiki_loaded = 1

" Initialize options
call wiki#init#option('wiki_journal', {
      \ 'name' : 'journal',
      \ 'frequency' : 'daily',
      \ 'date_format' : {
      \   'daily' : '%Y-%m-%d',
      \   'weekly' : '%Y_w%V',
      \   'monthly' : '%Y_m%m',
      \ },
      \})
call wiki#init#option('wiki_viewer', {
      \ '_' : get({
      \   'linux' : 'xdg-open',
      \   'mac' : 'open',
      \ }, wiki#init#get_os(), ''),
      \})
call wiki#init#option('wiki_export', {
      \ 'args' : '',
      \ 'from_format' : 'gfm',
      \ 'ext' : 'pdf',
      \ 'view' : v:false,
      \})
call wiki#init#option('wiki_tags', { 'output' : 'loclist' })
call wiki#init#option('wiki_filetypes', ['wiki'])
call wiki#init#option('wiki_index_name', 'index')
call wiki#init#option('wiki_root', '')
call wiki#init#option('wiki_link_extension', '')
call wiki#init#option('wiki_link_target_map', '')
call wiki#init#option('wiki_link_target_type', 'wiki')
call wiki#init#option('wiki_month_names', [
      \ 'January', 'February', 'March', 'April', 'May', 'June', 'July',
      \ 'August', 'September', 'October', 'November', 'December'
      \])
call wiki#init#option('wiki_template_title_week',
      \ '# Summary, %(year) week %(week)')
call wiki#init#option('wiki_template_title_month',
      \ '# Summary, %(year) %(month-name)')

" Initialize global commands
command! WikiEnable  call wiki#buffer#init()
command! WikiIndex   call wiki#goto_index()
command! WikiReload  call wiki#reload()
command! WikiJournal call wiki#journal#make_note()
command! CtrlPWiki   call ctrlp#init(ctrlp#wiki#id())

" Initialize mappings
nnoremap <silent> <plug>(wiki-index)   :WikiIndex<cr>
nnoremap <silent> <plug>(wiki-journal) :WikiJournal<cr>
nnoremap <silent> <plug>(wiki-reload)  :WikiReload<cr>

" Apply default mappings
let s:mappings = get(g:, 'wiki_mappings_use_defaults', 1)
      \ ? {
      \ '<plug>(wiki-index)' : '<leader>ww',
      \ '<plug>(wiki-journal)' : '<leader>w<leader>w',
      \ '<plug>(wiki-reload)' : '<leader>wx',
      \} : {}
call extend(s:mappings, get(g:, 'wiki_mappings_global', {}))
call wiki#init#apply_mappings_from_dict(s:mappings, '')

" Enable on desired filetypes
augroup wiki
  autocmd!
  for s:ft in g:wiki_filetypes
    execute 'autocmd BufRead,BufNewFile *.' . s:ft 'WikiEnable'
  endfor
augroup END
