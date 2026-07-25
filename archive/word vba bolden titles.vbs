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
    ' 4. Remove Citations
    ' ------------------------------------------------
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    
    ' First pass: Removes (standard formatting)
    With Selection.Find
        .Text = "\@\]"
        .Replacement.Text = ""
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchWildcards = True
    End With
    Selection.Find.Execute Replace:=wdReplaceAll

    ' Second pass: Removes [ cite: 1 ] (with extra spaces)
    With Selection.Find
        .Text = "\[cite: [0-9]@\]"
        .Replacement.Text = ""
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchWildcards = True
    End With
    Selection.Find.Execute Replace:=wdReplaceAll
    
    ' ------------------------------------------------
    ' 5. Replace [ __ ] with [ _____ ]
    ' ------------------------------------------------
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    
    With Selection.Find
        .Text = "[ __ ]"
        .Replacement.Text = "[ _____ ]"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchWildcards = False ' Wildcards disabled so brackets are treated as plain text
    End With
    Selection.Find.Execute Replace:=wdReplaceAll

    ' ------------------------------------------------
    ' Cleanup
    ' ------------------------------------------------
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    Application.ScreenUpdating = True
End Sub
