# Engineering Control Systems: A Practical Introduction for Mechanical, Civil, and Aerospace Engineers
This open-source text is designed to offer the reader a complete text on the basics of control theory within the context of Mechanical Engineering. 

<p align="center">
<img src="source_material/figures/Union-Pacific-119.jpg" alt="drawing" width="700"/>
</p>
<p align="center">
</p>

A current PDF version of the text can be found by clicking <a href="source_material/Engineering_Control_Systems.pdf">here</a>.

## Building the book

The book builds with Tectonic and uses TeX Gyre Termes for text and TeX Gyre
Termes Math for equations. Install both OpenType font families before building.
Run `make book-typography-check` to confirm that the regular, bold, italic,
bold-italic, and math faces are available and embedded correctly.

Review callouts use an optional semantic title and automatically inherit the
shared numbering and visual style:

```latex
\begin{review}[Newton's Three Laws of Motion]
  ...
\end{review}
```

Worked examples use the same optional-title pattern and support consistently
numbered instructional steps:

```latex
\begin{example}[Initial Displacement of a Vertical Spring--Mass System]
  \examplestep{Define the displacement direction.}
  ...
\end{example}
```

Editorial quotations use the warm Brass treatment:

```latex
\quotebox{All models are wrong, but some are useful.}
  {George E. P. Box (1919--2013)}
```

## License

This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License [cc-by-sa 4.0].

[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

## Citation

Cite as  
@Misc{DowneyEngineeringControlSystems,  
  author = {Austin Downey and Victor Giurgiutiu},  
  title  = {Engineering Control Systems},  
  url    = {https://github.com/austindowney/Engineering-Control-Systems},  
}  


