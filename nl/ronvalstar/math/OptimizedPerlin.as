/**
 Title:			Perlin noise
 Version:		1.2
 Author:			Ron Valstar
 Author URI:		http://www.sjeiti.com/
 Original code port from http://mrl.nyu.edu/~perlin/noise/
 and some help from http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
 AS3 optimizations by Mario Klingemann http://www.quasimondo.com
 */
package nl.ronvalstar.math {
	import flash.display.BitmapData;
	
	final public class OptimizedPerlin {
		
		private static const p:Array = [	
			151,160,137,91,90,15,131,13,201,95,
			96,53,194,233,7,225,140,36,103,30,69,
			142,8,99,37,240,21,10,23,190,6,148,
			247,120,234,75,0,26,197,62,94,252,
			219,203,117,35,11,32,57,177,33,88,
			237,149,56,87,174,20,125,136,171,
			168,68,175,74,165,71,134,139,48,27,
			166,77,146,158,231,83,111,229,122,
			60,211,133,230,220,105,92,41,55,46,
			245,40,244,102,143,54,65,25,63,161,
			1,216,80,73,209,76,132,187,208,89,
			18,169,200,196,135,130,116,188,159,
			86,164,100,109,198,173,186,3,64,52,
			217,226,250,124,123,5,202,38,147,118,
			126,255,82,85,212,207,206,59,227,47,
			16,58,17,182,189,28,42,223,183,170,
			213,119,248,152,2,44,154,163,70,221,
			153,101,155,167,43,172,9,129,22,39,
			253,19,98,108,110,79,113,224,232,
			178,185,112,104,218,246,97,228,251,
			34,242,193,238,210,144,12,191,179,
			162,241,81,51,145,235,249,14,239,
			107,49,192,214,31,181,199,106,157,
			184,84,204,176,115,121,50,45,127,4,
			150,254,138,236,205,93,222,114,67,29,
			24,72,243,141,128,195,78,66,215,61,
			156,180,151,160,137,91,90,15,131,13,
			201,95,96,53,194,233,7,225,140,36,
			103,30,69,142,8,99,37,240,21,10,23,
			190,6,148,247,120,234,75,0,26,197,
			62,94,252,219,203,117,35,11,32,57,
			177,33,88,237,149,56,87,174,20,125,
			136,171,168,68,175,74,165,71,134,139,
			48,27,166,77,146,158,231,83,111,229,
			122,60,211,133,230,220,105,92,41,55,
			46,245,40,244,102,143,54,65,25,63,
			161,1,216,80,73,209,76,132,187,208,
			89,18,169,200,196,135,130,116,188,
			159,86,164,100,109,198,173,186,3,64,
			52,217,226,250,124,123,5,202,38,147,
			118,126,255,82,85,212,207,206,59,
			227,47,16,58,17,182,189,28,42,223,
			183,170,213,119,248,152,2,44,154,
			163,70,221,153,101,155,167,43,172,9,
			129,22,39,253,19,98,108,110,79,113,
			224,232,178,185,112,104,218,246,97,
			228,251,34,242,193,238,210,144,12,
			191,179,162,241,81,51,145,235,249,
			14,239,107,49,192,214,31,181,199,
			106,157,184,84,204,176,115,121,50,
			45,127,4,150,254,138,236,205,93,
			222,114,67,29,24,72,243,141,128,
			195,78,66,215,61,156,180];
		
		private static var iOctaves:int = 4;
		private static var fPersistence:Number = .5;
		//
		private static var aOctFreq:Array; // frequency per octave
		private static var aOctPers:Array; // persistence per octave
		private static var fPersMax:Number;// 1 / max persistence
		//
		private static var iSeed:int = 123;
		
		private static var iXoffset:Number;
		private static var iYoffset:Number;
		private static var iZoffset:Number;
		
		private static const baseFactor:Number = 1 / 64;
		
		private static var initialized:Boolean = false
		
		//
		// PUBLIC
		public static function noise( $x:Number, $y:Number=1, $z:Number=1 ):Number 
		{
			if ( !initialized ) init();
			
			var s:Number = 0;
			var fFreq:Number, fPers:Number, x:Number, y:Number, z:Number;
			var xf:Number, yf:Number, zf:Number, u:Number, v:Number, w:Number;
			var x1:Number, y1:Number, z1:Number;
			var X:int, Y:int, Z:int, A:int, B:int, AA:int, AB:int, BA:int, BB:int, hash:int;
			var g1:Number, g2:Number, g3:Number, g4:Number, g5:Number, g6:Number, g7:Number, g8:Number;
			
			$x += iXoffset;
			$y += iYoffset;
			$z += iZoffset;
			
			for (var i:int;i<iOctaves;i++) 
			{
				fFreq = Number(aOctFreq[i]);
				fPers = Number(aOctPers[i]);
				
				x = $x * fFreq;
				y = $y * fFreq;
				z = $z * fFreq;
				
				xf = Math.floor(x);
				yf = Math.floor(y);
				zf = Math.floor(z);
				
				X = xf & 255;
				Y = yf & 255;
				Z = zf & 255;
				
				x -= xf;
				y -= yf;
				z -= zf;
				
				u = x * x * x * (x * (x*6 - 15) + 10);
				v = y * y * y * (y * (y*6 - 15) + 10);
				w = z * z * z * (z * (z*6 - 15) + 10);
				
				A  = int(p[X]) + Y; 
				AA = int(p[A]) + Z;
				AB = int(p[int(A+1)]) + Z;
				B  = int(p[int(X+1)]) + Y
				BA = int(p[B]) + Z
				BB = int(p[int(B+1)]) + Z;
				
				x1 = x-1;
				y1 = y-1;
				z1 = z-1;
				
				hash = int(p[int(BB+1)]) & 15;
				g1 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z1 ));
				
				hash = int(p[int(AB+1)]) & 15;
				g2 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x : -z1 ));
				
				hash = int(p[int(BA+1)]) & 15;
				g3 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z1 ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z1 ));
				
				hash = int(p[int(AA+1)]) & 15;
				g4 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z1 ) : hash<4 ? -y  : ( hash==14 ? -x  : -z1 ));
				
				hash = int(p[BB]) & 15;
				g5 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z  ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z  ));
				
				hash = int(p[AB]) & 15;
				g6 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z  ) : hash<4 ? -y1 : ( hash==14 ? -x  : -z  ));
				
				hash = int(p[BA]) & 15;
				g7 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z  ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z  ));
				
				hash = int(p[AA]) & 15;
				g8 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z  ) : hash<4 ? -y  : ( hash==14 ? -x  : -z  ));
				
				g2 += u * (g1 - g2);
				g4 += u * (g3 - g4);
				g6 += u * (g5 - g6);
				g8 += u * (g7 - g8);
				
				g4 += v * (g2 - g4);
				g8 += v * (g6 - g8);
				
				s += ( g8 + w * (g4 - g8)) * fPers;
			}
			
			return ( s * fPersMax + 1 ) * .5;
		}
		
		
		
		public static function fill( bitmap:BitmapData, $x:Number = 0, $y:Number = 0, $z:Number = 0 ):void 
		{
			if ( !initialized ) init();
			
			var s:Number = 0;
			var fFreq:Number, fPers:Number, x:Number, y:Number, z:Number;
			var xf:Number, yf:Number, zf:Number, u:Number, v:Number, w:Number;
			var x1:Number, y1:Number, z1:Number, baseX:Number, px:int, py:int;
			var i:int, X:int, Y:int, Z:int, A:int, B:int, AA:int, AB:int, BA:int, BB:int, hash:int;
			var g1:Number, g2:Number, g3:Number, g4:Number, g5:Number, g6:Number, g7:Number, g8:Number;
			var color:int;
			
			baseX = $x * baseFactor + iXoffset;
			$y = $y * baseFactor + iYoffset;
			$z = $z * baseFactor + iZoffset;
			
			var width:int = bitmap.width;
			var height:int = bitmap.height;
			
			for ( py = 0; py < height; py++ )
			{
				$x = baseX;
				
				for ( px = 0; px < width; px++ )
				{
					s = 0;
					
					for ( i = 0 ; i < iOctaves;i++) 
					{
						fFreq = Number(aOctFreq[i]);
						fPers = Number(aOctPers[i]);
						
						x = $x * fFreq;
						y = $y * fFreq;
						z = $z * fFreq;
						
						xf = Math.floor(x);
						yf = Math.floor(y);
						zf = Math.floor(z);
						
						X = xf & 255;
						Y = yf & 255;
						Z = zf & 255;
						
						x -= xf;
						y -= yf;
						z -= zf;
						
						u = x * x * x * (x * (x*6 - 15) + 10);
						v = y * y * y * (y * (y*6 - 15) + 10);
						w = z * z * z * (z * (z*6 - 15) + 10);
						
						A  = int(p[X]) + Y; 
						AA = int(p[A]) + Z;
						AB = int(p[int(A+1)]) + Z;
						B  = int(p[int(X+1)]) + Y
						BA = int(p[B]) + Z
						BB = int(p[int(B+1)]) + Z;
						
						x1 = x-1;
						y1 = y-1;
						z1 = z-1;
						
						hash = int(p[int(BB+1)]) & 15;
						g1 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z1 ));
						
						hash = int(p[int(AB+1)]) & 15;
						g2 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x : -z1 ));
						
						hash = int(p[int(BA+1)]) & 15;
						g3 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z1 ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z1 ));
						
						hash = int(p[int(AA+1)]) & 15;
						g4 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z1 ) : hash<4 ? -y  : ( hash==14 ? -x  : -z1 ));
						
						hash = int(p[BB]) & 15;
						g5 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z  ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z  ));
						
						hash = int(p[AB]) & 15;
						g6 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z  ) : hash<4 ? -y1 : ( hash==14 ? -x  : -z  ));
						
						hash = int(p[BA]) & 15;
						g7 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z  ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z  ));
						
						hash = int(p[AA]) & 15;
						g8 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z  ) : hash<4 ? -y  : ( hash==14 ? -x  : -z  ));
						
						g2 += u * (g1 - g2);
						g4 += u * (g3 - g4);
						g6 += u * (g5 - g6);
						g8 += u * (g7 - g8);
						
						g4 += v * (g2 - g4);
						g8 += v * (g6 - g8);
						
						s += ( g8 + w * (g4 - g8)) * fPers;
					}
					
					color = int( ( s * fPersMax + 1 ) * 128 )
					bitmap.setPixel32( px, py, 0xff000000 | color << 16 | color << 8 | color );
					
					$x += baseFactor;
				}
				
				$y += baseFactor;
			}
		}
		
		
		// GETTER / SETTER
		//
		// get octaves
		public static function get octaves():int 
		{
			return iOctaves;
		}
		// set octaves
		public static function set octaves(_iOctaves:int):void 
		{
			iOctaves = _iOctaves;
			octFreqPers();
		}
		//
		// get falloff
		public static function get falloff():Number 
		{
			return fPersistence;
		}
		// set falloff
		public static function set falloff(_fPersistence:Number):void 
		{
			fPersistence = _fPersistence;
			octFreqPers();
		}
		//
		// get seed
		public static function get seed():Number 
		{
			return iSeed;
		}
		// set seed
		public static function set seed(_iSeed:Number):void 
		{
			iSeed = _iSeed;
			seedOffset();
		}
		
		//
		// PRIVATE
		private static function init():void 
		{
			seedOffset();
			octFreqPers();
			initialized = true;
		}
		
		
		private static function octFreqPers():void 
		{
			var fFreq:Number, fPers:Number;
			
			aOctFreq = [];
			aOctPers = [];
			fPersMax = 0;
			
			for (var i:int;i<iOctaves;i++) 
			{
				fFreq = Math.pow(2,i);
				fPers = Math.pow(fPersistence,i);
				fPersMax += fPers;
				aOctFreq.push( fFreq );
				aOctPers.push( fPers );
			}
			
			fPersMax = 1 / fPersMax;
		}
		
		private static function seedOffset():void 
		{
			iXoffset = iSeed = (iSeed * 16807) % 2147483647;
			iYoffset = iSeed = (iSeed * 16807) % 2147483647;
			iZoffset = iSeed = (iSeed * 16807) % 2147483647;
		}
	}
}