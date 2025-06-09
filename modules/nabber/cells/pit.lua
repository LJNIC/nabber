prism.registerCell("Pit", function()
   return prism.Cell.fromComponents {
      prism.components.Drawable(1),
      prism.components.Name("Pit"),

      prism.components.Opaque(),
      prism.components.Collider({ allowedMovetypes = { "fly" } }),
   }
end)
