Sub FormatMarkdownText()
    Application.ScreenUpdating = False

    ' ------------------------------------------------
    ' 1. Fix Bold Text (**text**)
    ' ------------------------------------------------
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    Selection.Find.Replacement.Font.Bold = True
    
    With Selection.Find
        .Text = "\*\*([!\*]@)\*\*"
        .Replacement.Text = "\1"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = True
        .MatchWildcards = True
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
    
    ' ------------------------------------------------
    ' 2. Fix ### Subheadings (Makes them Bold & Underlined)
    ' ------------------------------------------------
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    Selection.Find.Replacement.Font.Bold = True
    Selection.Find.Replacement.Font.Underline = wdUnderlineSingle
    
    With Selection.Find
        .Text = "### ([!^13]@)^13"
        .Replacement.Text = "\1^p"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = True
        .MatchWildcards = True
    End With
    Selection.Find.Execute Replace:=wdReplaceAll

    ' ------------------------------------------------
    ' 3. Fix ## Main Titles (Makes them Bold & Size 14)
    ' ------------------------------------------------
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    Selection.Find.Replacement.Font.Bold = True
    Selection.Find.Replacement.Font.Size = 14
    
    With Selection.Find
        .Text = "## ([!^13]@)^13"
        .Replacement.Text = "\1^p"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = True
        .MatchWildcards = True
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
    
    ' ------------------------------------------------
    ' Cleanup
    ' ------------------------------------------------
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    Application.ScreenUpdating = True
End Sub
