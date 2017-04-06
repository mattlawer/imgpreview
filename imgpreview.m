//
//  main.m
//  imgpreview
//
//  Created by Mathieu Bolard on 04/02/14.
//  Copyright (c) 2014 Mathieu Bolard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <sys/ioctl.h> //winsize

//#define LNE_H 14
//#define COL_W 7

const float terminal_colors[256][3] = {
    { 0.0, 0.0, 0.0 },
    { 0.76, 0.22, 0.14 },
    { 0.36, 0.74, 0.17 },
    { 0.69, 0.68, 0.19 },
    { 0.33, 0.25, 0.88 },
    { 0.84, 0.32, 0.83 },
    { 0.33, 0.73, 0.78 },
    { 0.80, 0.80, 0.80 },
    { 0.51, 0.51, 0.51 },
    { 0.92, 0.25, 0.17 },
    { 0.45, 0.91, 0.22 },
    { 0.93, 0.93, 0.27 },
    { 0.38, 0.29, 0.97 },
    { 0.91, 0.36, 0.98 },
    { 0.44, 0.95, 0.95 },
    { 0.92, 0.92, 0.92 },
    { 0.19, 0.19, 0.19 },
    { 0.25, 0.16, 0.56 },
    { 0.29, 0.20, 0.72 },
    { 0.33, 0.25, 0.87 },
    { 0.36, 0.28, 0.97 },
    { 0.38, 0.29, 0.97 },
    { 0.24, 0.51, 0.15 },
    { 0.22, 0.50, 0.50 },
    { 0.22, 0.49, 0.66 },
    { 0.24, 0.49, 0.82 },
    { 0.27, 0.48, 0.97 },
    { 0.30, 0.47, 0.97 },
    { 0.31, 0.64, 0.16 },
    { 0.30, 0.64, 0.47 },
    { 0.29, 0.64, 0.63 },
    { 0.27, 0.63, 0.79 },
    { 0.25, 0.63, 0.95 },
    { 0.26, 0.62, 0.98 },
    { 0.38, 0.77, 0.18 },
    { 0.37, 0.77, 0.45 },
    { 0.36, 0.77, 0.61 },
    { 0.35, 0.67, 0.76 },
    { 0.34, 0.76, 0.92 },
    { 0.33, 0.76, 0.98 },
    { 0.44, 0.91, 0.22 },
    { 0.44, 0.90, 0.43 },
    { 0.44, 0.90, 0.58 },
    { 0.43, 0.90, 0.74 },
    { 0.42, 0.89, 0.89 },
    { 0.41, 0.89, 0.98 },
    { 0.41, 0.95, 0.23 },
    { 0.47, 0.95, 0.40 },
    { 0.46, 0.95, 0.55 },
    { 0.46, 0.96, 0.71 },
    { 0.46, 0.97, 0.87 },
    { 0.45, 0.98, 0.99 },
    { 0.55, 0.19, 0.15 },
    { 0.54, 0.20, 0.53 },
    { 0.54, 0.23, 0.69 },
    { 0.54, 0.27, 0.85 },
    { 0.55, 0.30, 0.97 },
    { 0.55, 0.31, 0.97 },
    { 0.50, 0.49, 0.15 },
    { 0.49, 0.49, 0.49 },
    { 0.49, 0.49, 0.65 },
    { 0.49, 0.48, 0.81 },
    { 0.49, 0.48, 0.97 },
    { 0.50, 0.47, 0.98 },
    { 0.47, 0.63, 0.16 },
    { 0.47, 0.63, 0.46 },
    { 0.47, 0.63, 0.62 },
    { 0.47, 0.62, 0.78 },
    { 0.47, 0.62, 0.95 },
    { 0.47, 0.61, 0.98 },
    { 0.45, 0.76, 0.18 },
    { 0.45, 0.76, 0.44 },
    { 0.45, 0.76, 0.60 },
    { 0.45, 0.76, 0.76 },
    { 0.45, 0.76, 0.91 },
    { 0.45, 0.75, 0.98 },
    { 0.44, 0.90, 0.22 },
    { 0.44, 0.89, 0.42 },
    { 0.43, 0.89, 0.57 },
    { 0.42, 0.89, 0.73 },
    { 0.42, 0.89, 0.89 },
    { 0.42, 0.88, 0.98 },
    { 0.47, 0.95, 0.23 },
    { 0.47, 0.95, 0.39 },
    { 0.46, 0.96, 0.55 },
    { 0.46, 0.96, 0.71 },
    { 0.46, 0.97, 0.86 },
    { 0.45, 0.98, 0.99 },
    { 0.70, 0.21, 0.13 },
    { 0.69, 0.22, 0.51 },
    { 0.68, 0.25, 0.67 },
    { 0.68, 0.29, 0.83 },
    { 0.68, 0.33, 0.98 },
    { 0.68, 0.33, 0.98 },
    { 0.65, 0.48, 0.15 },
    { 0.64, 0.48, 0.48 },
    { 0.64, 0.48, 0.64 },
    { 0.64, 0.47, 0.80 },
    { 0.64, 0.47, 0.96 },
    { 0.46, 0.47, 0.98 },
    { 0.63, 0.62, 0.17 },
    { 0.62, 0.62, 0.46 },
    { 0.62, 0.62, 0.62 },
    { 0.62, 0.62, 0.78 },
    { 0.62, 0.61, 0.93 },
    { 0.62, 0.61, 0.98 },
    { 0.60, 0.76, 0.20 },
    { 0.60, 0.76, 0.44 },
    { 0.60, 0.76, 0.60 },
    { 0.60, 0.75, 0.75 },
    { 0.59, 0.75, 0.91 },
    { 0.60, 0.75, 0.98 },
    { 0.58, 0.89, 0.22 },
    { 0.58, 0.89, 0.42 },
    { 0.57, 0.89, 0.57 },
    { 0.57, 0.89, 0.73 },
    { 0.57, 0.89, 0.89 },
    { 0.57, 0.88, 0.99 },
    { 0.53, 0.95, 0.24 },
    { 0.53, 0.95, 0.39 },
    { 0.53, 0.96, 0.55 },
    { 0.53, 0.96, 0.70 },
    { 0.53, 0.97, 0.86 },
    { 0.54, 0.98, 0.99 },
    { 0.84, 0.23, 0.15 },
    { 0.84, 0.26, 0.49 },
    { 0.83, 0.28, 0.66 },
    { 0.82, 0.31, 0.82 },
    { 0.82, 0.35, 0.97 },
    { 0.82, 0.35, 0.98 },
    { 0.80, 0.47, 0.17 },
    { 0.80, 0.47, 0.47 },
    { 0.80, 0.47, 0.63 },
    { 0.79, 0.47, 0.79 },
    { 0.79, 0.47, 0.95 },
    { 0.79, 0.46, 0.98 },
    { 0.78, 0.62, 0.19 },
    { 0.78, 0.61, 0.45 },
    { 0.77, 0.61, 0.61 },
    { 0.77, 0.61, 0.77 },
    { 0.77, 0.61, 0.93 },
    { 0.76, 0.60, 0.98 },
    { 0.75, 0.75, 0.21 },
    { 0.75, 0.75, 0.44 },
    { 0.75, 0.75, 0.59 },
    { 0.75, 0.75, 0.75 },
    { 0.75, 0.75, 0.90 },
    { 0.75, 0.74, 0.98 },
    { 0.73, 0.89, 0.24 },
    { 0.73, 0.89, 0.41 },
    { 0.73, 0.88, 0.57 },
    { 0.72, 0.88, 0.72 },
    { 0.72, 0.88, 0.88 },
    { 0.72, 0.88, 0.99 },
    { 0.69, 0.96, 0.25 },
    { 0.69, 0.96, 0.38 },
    { 0.69, 0.96, 0.54 },
    { 0.69, 0.97, 0.70 },
    { 0.69, 0.98, 0.85 },
    { 0.69, 0.98, 0.99 },
    { 0.92, 0.25, 0.87 },
    { 0.92, 0.28, 0.47 },
    { 0.92, 0.30, 0.64 },
    { 0.92, 0.33, 0.80 },
    { 0.91, 0.36, 0.95 },
    { 0.91, 0.36, 0.98 },
    { 0.93, 0.46, 0.19 },
    { 0.93, 0.46, 0.45 },
    { 0.96, 0.46, 0.62 },
    { 0.93, 0.46, 0.77 },
    { 0.92, 0.43, 0.93 },
    { 0.92, 0.45, 0.98 },
    { 0.93, 0.60, 0.21 },
    { 0.93, 0.60, 0.44 },
    { 0.93, 0.60, 0.60 },
    { 0.92, 0.60, 0.76 },
    { 0.92, 0.60, 0.92 },
    { 0.92, 0.60, 0.98 },
    { 0.91, 0.75, 0.23 },
    { 0.90, 0.74, 0.42 },
    { 0.90, 0.74, 0.58 },
    { 0.90, 0.74, 0.74 },
    { 0.90, 0.74, 0.89 },
    { 0.89, 0.73, 0.99 },
    { 0.88, 0.88, 0.25 },
    { 0.88, 0.88, 0.41 },
    { 0.88, 0.88, 0.56 },
    { 0.87, 0.87, 0.72 },
    { 0.87, 0.87, 0.87 },
    { 0.87, 0.87, 0.99 },
    { 0.85, 0.97, 0.27 },
    { 0.84, 0.96, 0.38 },
    { 0.85, 0.97, 0.54 },
    { 0.85, 0.98, 0.69 },
    { 0.85, 0.98, 0.85 },
    { 0.95, 0.99, 1.00 },
    { 0.92, 0.25, 0.17 },
    { 0.92, 0.27, 0.45 },
    { 0.92, 0.30, 0.60 },
    { 0.92, 0.33, 0.78 },
    { 0.91, 0.36, 0.94 },
    { 0.91, 0.36, 0.98 },
    { 0.93, 0.45, 0.19 },
    { 0.93, 0.45, 0.44 },
    { 0.93, 0.44, 0.60 },
    { 0.93, 0.44, 0.76 },
    { 0.92, 0.44, 0.92 },
    { 0.92, 0.44, 0.98 },
    { 0.95, 0.59, 0.22 },
    { 0.94, 0.59, 0.43 },
    { 0.94, 0.58, 0.59 },
    { 0.94, 0.58, 0.75 },
    { 0.93, 0.58, 0.90 },
    { 0.93, 0.58, 0.98 },
    { 0.96, 0.73, 0.24 },
    { 0.96, 0.73, 0.41 },
    { 0.96, 0.73, 0.57 },
    { 0.96, 0.73, 0.73 },
    { 0.95, 0.73, 0.89 },
    { 0.95, 0.72, 0.99 },
    { 0.98, 0.87, 0.27 },
    { 0.98, 0.87, 0.40 },
    { 0.98, 0.87, 0.55 },
    { 0.98, 0.87, 0.71 },
    { 0.98, 0.86, 0.87 },
    { 0.97, 0.86, 0.99 },
    { 1.00, 0.97, 0.29 },
    { 1.00, 0.98, 0.37 },
    { 1.00, 0.98, 0.53 },
    { 1.00, 0.98, 0.69 },
    { 1.00, 0.99, 0.84 },
    { 1.00, 1.00, 1.00 },
    { 0.20, 0.20, 0.20 },
    { 0.23, 0.23, 0.23 },
    { 0.26, 0.26, 0.26 },
    { 0.30, 0.30, 0.30 },
    { 0.33, 0.33, 0.33 },
    { 0.36, 0.36, 0.36 },
    { 0.40, 0.40, 0.40 },
    { 0.43, 0.43, 0.43 },
    { 0.47, 0.47, 0.47 },
    { 0.50, 0.50, 0.50 },
    { 0.53, 0.53, 0.53 },
    { 0.56, 0.56, 0.56 },
    { 0.60, 0.60, 0.60 },
    { 0.63, 0.63, 0.63 },
    { 0.66, 0.66, 0.66 },
    { 0.69, 0.69, 0.69 },
    { 0.73, 0.73, 0.73 },
    { 0.76, 0.76, 0.76 },
    { 0.79, 0.79, 0.79 },
    { 0.82, 0.82, 0.82 },
    { 0.85, 0.85, 0.85 },
    { 0.88, 0.88, 0.88 },
    { 0.91, 0.91, 0.91 },
    { 0.95, 0.95, 0.95 } };


typedef struct {
    float r;
    float g;
    float b;
}pixel;


pixel getpixel(const unsigned char* data,int wid,long bpp,int x,int y){
    long ro,go,bo;
    pixel p;
    ro = ((y*wid + x)*bpp);
    go = ((y*wid + x)*bpp)+bpp/3;
    bo = ((y*wid + x)*bpp)+bpp/3*2;
    p.r = *((data+ro/8));
    p.g = *((data+go/8));
    p.b = *((data+bo/8));
    return p;
}

float distance_px(pixel *p1, pixel *p2) {
    return sqrtf((p1->r-p2->r)*(p1->r-p2->r) + (p1->g-p2->g)*(p1->g-p2->g) + (p1->b-p2->b)*(p1->b-p2->b));
}

int nearest_color (pixel *p) {
    int i = 0, index = 0;
    float distance = 255.0;
    float tmp_distance;
    pixel tmp;
    for (i = 0; i<256; i++) {
        tmp.r = terminal_colors[i][0];
        tmp.g = terminal_colors[i][1];
        tmp.b = terminal_colors[i][2];
        tmp_distance = distance_px(p, &tmp);
        if (tmp_distance < distance) {
            distance = tmp_distance;
            index = i;
        }
    }
    return index;
}

void print_pixel(int a, int g, int n, pixel *p) {
    static int lastColor = -1;
    NSString *ch = @"█";
    if (a || n) {
        char levels[10] = " .:;+=xX$&";
        ch = [NSString stringWithFormat:@"%c",levels[(int)floor((p->r+p->g+p->b)*3.0)]];
    }
    if (n) {
        printf("%s", ch.UTF8String);
    } else if (g) {
        int color = ((p->r+p->g+p->b)/3.0)*24.0 < 1 ? 16 : (int)(231+ceilf(((p->r+p->g+p->b)/3.0)*24.0));
        if (lastColor != color) {
            printf("\e[38;05;%dm%s", color, ch.UTF8String);
        } else {
            printf("%s", ch.UTF8String);
        }
        lastColor = color;
    } else {
        int color = nearest_color(p);
        if (lastColor != color) {
            printf("\e[38;05;%dm%s", color ,ch.UTF8String);
        } else {
            printf("%s", ch.UTF8String);
        }
        lastColor = color;
    }
}

void print_usage(void) {
    printf("Usage : imgpreview [-a -g -n] <image>\n");
    printf("\t-a : use ascii\n");
    printf("\t-g : use grayscale\n");
    printf("\t-n : no colors\n");
    
    printf("\nexemple : imgpreview -an ./test.png\n");
}

int main(int argc, char *const argv[])
{
    @autoreleasepool {
        int aflag = 0;
        int gflag = 0;
        int nflag = 0;
        const char *imgfile = NULL;
        int index;
        int c,l, pc,pl;
        
        opterr = 0;
        
        while ((c = getopt (argc, argv, ":i:agn")) != -1)
            switch (c)
        {
            case 'a':
                aflag = 1;
                break;
            case 'g':
                gflag = 1;
                break;
            case 'n':
                nflag = 1;
                break;
            case 'h':
                nflag = 1;
                break;
            case '?':
                if (isprint (optopt))
                    fprintf (stderr, "Unknown option `-%c'.\n", optopt);
                else
                    fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
                print_usage();
                return 1;
            default:
                print_usage();
                abort();
        }
        
        //printf ("aflag = %d, gflag = %d, nflag = %d\n", aflag, gflag, nflag);
        
        NSImage *image = nil;
        NSBitmapImageRep* raw_img = nil;
        unsigned char* bitmap_data = NULL;
        NSInteger bpp;
        int h, w;
        
        if (optind == argc) {
            print_usage();
            return 0;
        }
        
        //int columns = atoi(getenv("COLUMNS"));
        struct winsize windowsize;
        ioctl(STDOUT_FILENO, TIOCGWINSZ, &windowsize);
        int columns = windowsize.ws_col;
        
        for (index = optind; index < argc; index++) {
            // for all images
            imgfile = argv[index];
            if (access(imgfile, F_OK) == -1) {
                fprintf(stderr, "can't access %s\n",imgfile);
                continue;
            }
            
            image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:imgfile]];
            printf("image : %s (%.0f:%.0f)\n",imgfile, image.size.width, image.size.height);
            
            raw_img = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
            bitmap_data = [raw_img bitmapData];
            bpp = [raw_img bitsPerPixel];
            w = (int)[raw_img bytesPerRow]/(bpp/8);
            h = ((int)([raw_img bytesPerPlane]*[raw_img numberOfPlanes])/(bpp/8))/w;
            
            int colW = ceil((float)w/columns);
            int lineH = colW*2;
            
            // pour chaques lignes
            for (l = 0; l < (h-(h%lineH))/lineH; l++) {
                // pour chaques cononnes
                for (c = 0; c < (w-(w%colW))/colW; c++) {
                    
                    pixel sum;
                    sum.r = 0.0;
                    sum.g = 0.0;
                    sum.b = 0.0;
                    
                    for (pl = 0; pl < lineH; pl++) {
                        for (pc = 0; pc < colW; pc++) {
                            pixel p = getpixel(bitmap_data, w, bpp, (c*colW)+pc, (l*lineH)+pl);
                            sum.r += p.r;
                            sum.g += p.g;
                            sum.b += p.b;
                        }
                    }
                    sum.r /= lineH*colW*255;
                    sum.g /= lineH*colW*255;
                    sum.b /= lineH*colW*255;
                    
                    print_pixel(aflag,gflag,nflag,&sum);                    
                }
                printf("\n");
            }
            printf("\e[m");
        }
    }
    return 0;
}

