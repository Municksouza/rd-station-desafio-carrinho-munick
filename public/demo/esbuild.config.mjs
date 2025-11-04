import esbuild from 'esbuild';

esbuild.build({
  entryPoints: ['./public/demo/js/main.js'], // ponto de entrada
  bundle: true,                       // empacotar tudo
  minify: true,                       // minificar
  sourcemap: true,                    // gerar mapa de origem
  target: ['es2020'],                 // compatibilidade moderna
  outfile: './public/demo/dist/bundle.js',        // saída
  format: 'esm',                      // mantém módulos ES6
  logLevel: 'info',
}).catch(() => process.exit(1));
