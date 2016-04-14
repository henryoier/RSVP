% Script generated by Brainstorm (08-Feb-2016)

% Input files
sFiles = {...
    'rsvp_07/101/data_101_trial001___COND101___.mat', ...
    'rsvp_07/101/data_101_trial002___COND101___.mat', ...
    'rsvp_07/101/data_101_trial003___COND101___.mat', ...
    'rsvp_07/101/data_101_trial004___COND101___.mat', ...
    'rsvp_07/101/data_101_trial005___COND101___.mat', ...
    'rsvp_07/101/data_101_trial006___COND101___.mat', ...
    'rsvp_07/101/data_101_trial007___COND101___.mat', ...
    'rsvp_07/101/data_101_trial008___COND101___.mat', ...
    'rsvp_07/101/data_101_trial009___COND101___.mat', ...
    'rsvp_07/101/data_101_trial010___COND101___.mat', ...
    'rsvp_07/101/data_101_trial011___COND101___.mat', ...
    'rsvp_07/101/data_101_trial012___COND101___.mat', ...
    'rsvp_07/102/data_102_trial001___COND102___.mat', ...
    'rsvp_07/102/data_102_trial003___COND102___.mat', ...
    'rsvp_07/102/data_102_trial004___COND102___.mat', ...
    'rsvp_07/102/data_102_trial005___COND102___.mat', ...
    'rsvp_07/102/data_102_trial006___COND102___.mat', ...
    'rsvp_07/102/data_102_trial007___COND102___.mat', ...
    'rsvp_07/102/data_102_trial008___COND102___.mat', ...
    'rsvp_07/102/data_102_trial009___COND102___.mat', ...
    'rsvp_07/102/data_102_trial010___COND102___.mat', ...
    'rsvp_07/102/data_102_trial011___COND102___.mat', ...
    'rsvp_07/103/data_103_trial001___COND103___.mat', ...
    'rsvp_07/103/data_103_trial002___COND103___.mat', ...
    'rsvp_07/103/data_103_trial003___COND103___.mat', ...
    'rsvp_07/103/data_103_trial004___COND103___.mat', ...
    'rsvp_07/103/data_103_trial005___COND103___.mat', ...
    'rsvp_07/103/data_103_trial006___COND103___.mat', ...
    'rsvp_07/103/data_103_trial007___COND103___.mat', ...
    'rsvp_07/103/data_103_trial008___COND103___.mat', ...
    'rsvp_07/104/data_104_trial001___COND104___.mat', ...
    'rsvp_07/104/data_104_trial002___COND104___.mat', ...
    'rsvp_07/104/data_104_trial003___COND104___.mat', ...
    'rsvp_07/104/data_104_trial004___COND104___.mat', ...
    'rsvp_07/104/data_104_trial005___COND104___.mat', ...
    'rsvp_07/104/data_104_trial006___COND104___.mat', ...
    'rsvp_07/104/data_104_trial007___COND104___.mat', ...
    'rsvp_07/104/data_104_trial008___COND104___.mat', ...
    'rsvp_07/104/data_104_trial009___COND104___.mat', ...
    'rsvp_07/104/data_104_trial010___COND104___.mat', ...
    'rsvp_07/105/data_105_trial001___COND105___.mat', ...
    'rsvp_07/105/data_105_trial002___COND105___.mat', ...
    'rsvp_07/105/data_105_trial003___COND105___.mat', ...
    'rsvp_07/105/data_105_trial004___COND105___.mat', ...
    'rsvp_07/105/data_105_trial005___COND105___.mat', ...
    'rsvp_07/105/data_105_trial006___COND105___.mat', ...
    'rsvp_07/105/data_105_trial007___COND105___.mat', ...
    'rsvp_07/105/data_105_trial008___COND105___.mat', ...
    'rsvp_07/105/data_105_trial009___COND105___.mat', ...
    'rsvp_07/105/data_105_trial010___COND105___.mat', ...
    'rsvp_07/105/data_105_trial011___COND105___.mat', ...
    'rsvp_07/105/data_105_trial012___COND105___.mat', ...
    'rsvp_07/105/data_105_trial013___COND105___.mat', ...
    'rsvp_07/105/data_105_trial014___COND105___.mat', ...
    'rsvp_07/106/data_106_trial001___COND106___.mat', ...
    'rsvp_07/106/data_106_trial003___COND106___.mat', ...
    'rsvp_07/106/data_106_trial004___COND106___.mat', ...
    'rsvp_07/106/data_106_trial005___COND106___.mat', ...
    'rsvp_07/106/data_106_trial006___COND106___.mat', ...
    'rsvp_07/106/data_106_trial007___COND106___.mat', ...
    'rsvp_07/106/data_106_trial008___COND106___.mat', ...
    'rsvp_07/107/data_107_trial001___COND107___.mat', ...
    'rsvp_07/107/data_107_trial002___COND107___.mat', ...
    'rsvp_07/107/data_107_trial003___COND107___.mat', ...
    'rsvp_07/107/data_107_trial004___COND107___.mat', ...
    'rsvp_07/107/data_107_trial005___COND107___.mat', ...
    'rsvp_07/107/data_107_trial006___COND107___.mat', ...
    'rsvp_07/107/data_107_trial007___COND107___.mat', ...
    'rsvp_07/107/data_107_trial008___COND107___.mat', ...
    'rsvp_07/107/data_107_trial009___COND107___.mat', ...
    'rsvp_07/108/data_108_trial001___COND108___.mat', ...
    'rsvp_07/108/data_108_trial002___COND108___.mat', ...
    'rsvp_07/108/data_108_trial004___COND108___.mat', ...
    'rsvp_07/108/data_108_trial005___COND108___.mat', ...
    'rsvp_07/108/data_108_trial006___COND108___.mat', ...
    'rsvp_07/108/data_108_trial007___COND108___.mat', ...
    'rsvp_07/108/data_108_trial008___COND108___.mat', ...
    'rsvp_07/108/data_108_trial009___COND108___.mat', ...
    'rsvp_07/108/data_108_trial010___COND108___.mat', ...
    'rsvp_07/108/data_108_trial012___COND108___.mat', ...
    'rsvp_07/109/data_109_trial002___COND109___.mat', ...
    'rsvp_07/109/data_109_trial003___COND109___.mat', ...
    'rsvp_07/109/data_109_trial004___COND109___.mat', ...
    'rsvp_07/109/data_109_trial005___COND109___.mat', ...
    'rsvp_07/109/data_109_trial006___COND109___.mat', ...
    'rsvp_07/110/data_110_trial001___COND110___.mat', ...
    'rsvp_07/110/data_110_trial002___COND110___.mat', ...
    'rsvp_07/110/data_110_trial003___COND110___.mat', ...
    'rsvp_07/110/data_110_trial004___COND110___.mat', ...
    'rsvp_07/110/data_110_trial005___COND110___.mat', ...
    'rsvp_07/110/data_110_trial006___COND110___.mat', ...
    'rsvp_07/110/data_110_trial007___COND110___.mat', ...
    'rsvp_07/110/data_110_trial008___COND110___.mat', ...
    'rsvp_07/110/data_110_trial009___COND110___.mat', ...
    'rsvp_07/110/data_110_trial010___COND110___.mat', ...
    'rsvp_07/111/data_111_trial003___COND111___.mat', ...
    'rsvp_07/111/data_111_trial004___COND111___.mat', ...
    'rsvp_07/111/data_111_trial005___COND111___.mat', ...
    'rsvp_07/111/data_111_trial006___COND111___.mat', ...
    'rsvp_07/111/data_111_trial007___COND111___.mat', ...
    'rsvp_07/111/data_111_trial008___COND111___.mat', ...
    'rsvp_07/111/data_111_trial009___COND111___.mat', ...
    'rsvp_07/111/data_111_trial010___COND111___.mat', ...
    'rsvp_07/111/data_111_trial011___COND111___.mat', ...
    'rsvp_07/111/data_111_trial012___COND111___.mat', ...
    'rsvp_07/111/data_111_trial013___COND111___.mat', ...
    'rsvp_07/112/data_112_trial001___COND112___.mat', ...
    'rsvp_07/112/data_112_trial003___COND112___.mat', ...
    'rsvp_07/112/data_112_trial004___COND112___.mat', ...
    'rsvp_07/112/data_112_trial005___COND112___.mat', ...
    'rsvp_07/112/data_112_trial006___COND112___.mat', ...
    'rsvp_07/112/data_112_trial008___COND112___.mat', ...
    'rsvp_07/112/data_112_trial009___COND112___.mat', ...
    'rsvp_07/113/data_113_trial002___COND113___.mat', ...
    'rsvp_07/113/data_113_trial003___COND113___.mat', ...
    'rsvp_07/113/data_113_trial006___COND113___.mat', ...
    'rsvp_07/113/data_113_trial007___COND113___.mat', ...
    'rsvp_07/113/data_113_trial008___COND113___.mat', ...
    'rsvp_07/113/data_113_trial009___COND113___.mat', ...
    'rsvp_07/113/data_113_trial010___COND113___.mat', ...
    'rsvp_07/113/data_113_trial011___COND113___.mat', ...
    'rsvp_07/113/data_113_trial012___COND113___.mat', ...
    'rsvp_07/113/data_113_trial013___COND113___.mat', ...
    'rsvp_07/113/data_113_trial014___COND113___.mat', ...
    'rsvp_07/114/data_114_trial001___COND114___.mat', ...
    'rsvp_07/114/data_114_trial002___COND114___.mat', ...
    'rsvp_07/114/data_114_trial003___COND114___.mat', ...
    'rsvp_07/114/data_114_trial004___COND114___.mat', ...
    'rsvp_07/114/data_114_trial005___COND114___.mat', ...
    'rsvp_07/114/data_114_trial006___COND114___.mat', ...
    'rsvp_07/114/data_114_trial007___COND114___.mat', ...
    'rsvp_07/114/data_114_trial008___COND114___.mat', ...
    'rsvp_07/114/data_114_trial009___COND114___.mat', ...
    'rsvp_07/114/data_114_trial010___COND114___.mat', ...
    'rsvp_07/114/data_114_trial011___COND114___.mat', ...
    'rsvp_07/114/data_114_trial013___COND114___.mat', ...
    'rsvp_07/114/data_114_trial014___COND114___.mat', ...
    'rsvp_07/115/data_115_trial002___COND115___.mat', ...
    'rsvp_07/115/data_115_trial003___COND115___.mat', ...
    'rsvp_07/115/data_115_trial004___COND115___.mat', ...
    'rsvp_07/115/data_115_trial005___COND115___.mat', ...
    'rsvp_07/115/data_115_trial006___COND115___.mat', ...
    'rsvp_07/115/data_115_trial007___COND115___.mat', ...
    'rsvp_07/115/data_115_trial008___COND115___.mat', ...
    'rsvp_07/115/data_115_trial009___COND115___.mat', ...
    'rsvp_07/115/data_115_trial010___COND115___.mat', ...
    'rsvp_07/115/data_115_trial011___COND115___.mat', ...
    'rsvp_07/116/data_116_trial001___COND116___.mat', ...
    'rsvp_07/116/data_116_trial002___COND116___.mat', ...
    'rsvp_07/116/data_116_trial003___COND116___.mat', ...
    'rsvp_07/116/data_116_trial004___COND116___.mat', ...
    'rsvp_07/116/data_116_trial005___COND116___.mat', ...
    'rsvp_07/116/data_116_trial006___COND116___.mat', ...
    'rsvp_07/116/data_116_trial007___COND116___.mat', ...
    'rsvp_07/116/data_116_trial008___COND116___.mat', ...
    'rsvp_07/117/data_117_trial001___COND117___.mat', ...
    'rsvp_07/117/data_117_trial002___COND117___.mat', ...
    'rsvp_07/117/data_117_trial003___COND117___.mat', ...
    'rsvp_07/117/data_117_trial004___COND117___.mat', ...
    'rsvp_07/117/data_117_trial005___COND117___.mat', ...
    'rsvp_07/118/data_118_trial001___COND118___.mat', ...
    'rsvp_07/118/data_118_trial002___COND118___.mat', ...
    'rsvp_07/118/data_118_trial003___COND118___.mat', ...
    'rsvp_07/118/data_118_trial004___COND118___.mat', ...
    'rsvp_07/118/data_118_trial005___COND118___.mat', ...
    'rsvp_07/118/data_118_trial006___COND118___.mat', ...
    'rsvp_07/118/data_118_trial007___COND118___.mat', ...
    'rsvp_07/118/data_118_trial008___COND118___.mat', ...
    'rsvp_07/119/data_119_trial001___COND119___.mat', ...
    'rsvp_07/119/data_119_trial002___COND119___.mat', ...
    'rsvp_07/119/data_119_trial003___COND119___.mat', ...
    'rsvp_07/119/data_119_trial004___COND119___.mat', ...
    'rsvp_07/119/data_119_trial005___COND119___.mat', ...
    'rsvp_07/119/data_119_trial006___COND119___.mat', ...
    'rsvp_07/119/data_119_trial007___COND119___.mat', ...
    'rsvp_07/119/data_119_trial008___COND119___.mat', ...
    'rsvp_07/119/data_119_trial009___COND119___.mat', ...
    'rsvp_07/119/data_119_trial010___COND119___.mat', ...
    'rsvp_07/119/data_119_trial011___COND119___.mat', ...
    'rsvp_07/120/data_120_trial001___COND120___.mat', ...
    'rsvp_07/120/data_120_trial002___COND120___.mat', ...
    'rsvp_07/120/data_120_trial003___COND120___.mat', ...
    'rsvp_07/120/data_120_trial004___COND120___.mat', ...
    'rsvp_07/120/data_120_trial005___COND120___.mat', ...
    'rsvp_07/120/data_120_trial006___COND120___.mat', ...
    'rsvp_07/120/data_120_trial007___COND120___.mat', ...
    'rsvp_07/120/data_120_trial008___COND120___.mat', ...
    'rsvp_07/120/data_120_trial009___COND120___.mat', ...
    'rsvp_07/121/data_121_trial002___COND121___.mat', ...
    'rsvp_07/121/data_121_trial003___COND121___.mat', ...
    'rsvp_07/121/data_121_trial004___COND121___.mat', ...
    'rsvp_07/121/data_121_trial005___COND121___.mat', ...
    'rsvp_07/121/data_121_trial006___COND121___.mat', ...
    'rsvp_07/121/data_121_trial007___COND121___.mat', ...
    'rsvp_07/121/data_121_trial008___COND121___.mat', ...
    'rsvp_07/122/data_122_trial001___COND122___.mat', ...
    'rsvp_07/122/data_122_trial002___COND122___.mat', ...
    'rsvp_07/122/data_122_trial003___COND122___.mat', ...
    'rsvp_07/122/data_122_trial004___COND122___.mat', ...
    'rsvp_07/122/data_122_trial005___COND122___.mat', ...
    'rsvp_07/122/data_122_trial006___COND122___.mat', ...
    'rsvp_07/122/data_122_trial007___COND122___.mat', ...
    'rsvp_07/122/data_122_trial008___COND122___.mat', ...
    'rsvp_07/122/data_122_trial009___COND122___.mat', ...
    'rsvp_07/123/data_123_trial001___COND123___.mat', ...
    'rsvp_07/123/data_123_trial002___COND123___.mat', ...
    'rsvp_07/123/data_123_trial003___COND123___.mat', ...
    'rsvp_07/123/data_123_trial004___COND123___.mat', ...
    'rsvp_07/123/data_123_trial005___COND123___.mat', ...
    'rsvp_07/123/data_123_trial006___COND123___.mat', ...
    'rsvp_07/123/data_123_trial007___COND123___.mat', ...
    'rsvp_07/123/data_123_trial008___COND123___.mat', ...
    'rsvp_07/123/data_123_trial009___COND123___.mat', ...
    'rsvp_07/123/data_123_trial010___COND123___.mat', ...
    'rsvp_07/123/data_123_trial011___COND123___.mat', ...
    'rsvp_07/123/data_123_trial012___COND123___.mat', ...
    'rsvp_07/123/data_123_trial013___COND123___.mat', ...
    'rsvp_07/123/data_123_trial014___COND123___.mat', ...
    'rsvp_07/124/data_124_trial001___COND124___.mat', ...
    'rsvp_07/124/data_124_trial002___COND124___.mat', ...
    'rsvp_07/124/data_124_trial003___COND124___.mat', ...
    'rsvp_07/124/data_124_trial005___COND124___.mat', ...
    'rsvp_07/124/data_124_trial006___COND124___.mat', ...
    'rsvp_07/124/data_124_trial007___COND124___.mat', ...
    'rsvp_07/124/data_124_trial008___COND124___.mat', ...
    'rsvp_07/124/data_124_trial009___COND124___.mat', ...
    'rsvp_07/124/data_124_trial010___COND124___.mat', ...
    'rsvp_07/124/data_124_trial011___COND124___.mat', ...
    'rsvp_07/124/data_124_trial014___COND124___.mat'};

% Start a new report
bst_report('Start', sFiles);

% Process: Add time offset: -26.00ms
sFiles = bst_process('CallProcess', 'process_timeoffset', sFiles, [], ...
    'info', [], ...
    'offset', -0.026, ...
    'overwrite', 1);

% Save and display report
ReportFile = bst_report('Save', sFiles);
bst_report('Open', ReportFile);
