
objs/sqrt_ispc.o：     文件格式 elf64-x86-64


Disassembly of section .text:

0000000000000000 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_>:
   0:	8d 47 07             	lea    0x7(%rdi),%eax
   3:	85 ff                	test   %edi,%edi
   5:	0f 49 c7             	cmovns %edi,%eax
   8:	c5 fa 59 c8          	vmulss %xmm0,%xmm0,%xmm1
   c:	83 e0 f8             	and    $0xfffffff8,%eax
   f:	0f 8e f8 00 00 00    	jle    10d <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x10d>
  15:	c4 e2 7d 18 d0       	vbroadcastss %xmm0,%ymm2
  1a:	c4 e2 7d 18 d9       	vbroadcastss %xmm1,%ymm3
  1f:	89 c1                	mov    %eax,%ecx
  21:	31 c0                	xor    %eax,%eax
  23:	c4 e2 7d 18 25 00 00 	vbroadcastss 0x0(%rip),%ymm4        # 2c <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x2c>
  2a:	00 00 
  2c:	c4 e2 7d 18 2d 00 00 	vbroadcastss 0x0(%rip),%ymm5        # 35 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x35>
  33:	00 00 
  35:	c4 e2 7d 18 35 00 00 	vbroadcastss 0x0(%rip),%ymm6        # 3e <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x3e>
  3c:	00 00 
  3e:	c4 e2 7d 18 3d 00 00 	vbroadcastss 0x0(%rip),%ymm7        # 47 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x47>
  45:	00 00 
  47:	c4 62 7d 18 05 00 00 	vbroadcastss 0x0(%rip),%ymm8        # 50 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x50>
  4e:	00 00 
  50:	eb 26                	jmp    78 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x78>
  52:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
  59:	1f 84 00 00 00 00 00 
  60:	c4 41 34 59 cb       	vmulps %ymm11,%ymm9,%ymm9
  65:	c4 21 7c 11 0c 02    	vmovups %ymm9,(%rdx,%r8,1)
  6b:	48 83 c0 08          	add    $0x8,%rax
  6f:	48 39 c8             	cmp    %rcx,%rax
  72:	0f 83 97 00 00 00    	jae    10f <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x10f>
  78:	41 89 c0             	mov    %eax,%r8d
  7b:	41 81 e0 f8 ff ff 3f 	and    $0x3ffffff8,%r8d
  82:	49 c1 e0 02          	shl    $0x2,%r8
  86:	c4 21 7c 10 0c 06    	vmovups (%rsi,%r8,1),%ymm9
  8c:	c4 41 7c 28 e1       	vmovaps %ymm9,%ymm12
  91:	c4 62 65 a8 e4       	vfmadd213ps %ymm4,%ymm3,%ymm12
  96:	c5 1c 54 d5          	vandps %ymm5,%ymm12,%ymm10
  9a:	c4 41 4c c2 d2 01    	vcmpltps %ymm10,%ymm6,%ymm10
  a0:	c4 41 7c 50 ca       	vmovmskps %ymm10,%r9d
  a5:	c5 7c 28 da          	vmovaps %ymm2,%ymm11
  a9:	45 85 c9             	test   %r9d,%r9d
  ac:	74 b2                	je     60 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x60>
  ae:	c5 1c 54 e5          	vandps %ymm5,%ymm12,%ymm12
  b2:	c5 7c 28 da          	vmovaps %ymm2,%ymm11
  b6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  bd:	00 00 00 
  c0:	c4 41 34 59 eb       	vmulps %ymm11,%ymm9,%ymm13
  c5:	c4 41 24 59 ed       	vmulps %ymm13,%ymm11,%ymm13
  ca:	c4 41 24 59 ed       	vmulps %ymm13,%ymm11,%ymm13
  cf:	c4 62 25 ba ef       	vfmsub231ps %ymm7,%ymm11,%ymm13
  d4:	c4 41 14 59 e8       	vmulps %ymm8,%ymm13,%ymm13
  d9:	c4 43 25 4a dd a0    	vblendvps %ymm10,%ymm13,%ymm11,%ymm11
  df:	c4 41 24 59 eb       	vmulps %ymm11,%ymm11,%ymm13
  e4:	c4 62 35 a8 ec       	vfmadd213ps %ymm4,%ymm9,%ymm13
  e9:	c5 14 54 ed          	vandps %ymm5,%ymm13,%ymm13
  ed:	c4 43 1d 4a e5 a0    	vblendvps %ymm10,%ymm13,%ymm12,%ymm12
  f3:	c4 41 4c c2 ec 01    	vcmpltps %ymm12,%ymm6,%ymm13
  f9:	c4 41 14 54 d2       	vandps %ymm10,%ymm13,%ymm10
  fe:	c4 41 7c 50 ca       	vmovmskps %ymm10,%r9d
 103:	45 85 c9             	test   %r9d,%r9d
 106:	75 b8                	jne    c0 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0xc0>
 108:	e9 53 ff ff ff       	jmpq   60 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x60>
 10d:	31 c0                	xor    %eax,%eax
 10f:	39 f8                	cmp    %edi,%eax
 111:	0f 8d e3 00 00 00    	jge    1fa <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x1fa>
 117:	c5 f9 6e d0          	vmovd  %eax,%xmm2
 11b:	c4 e2 7d 58 d2       	vpbroadcastd %xmm2,%ymm2
 120:	c5 ed eb 15 00 00 00 	vpor   0x0(%rip),%ymm2,%ymm2        # 128 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x128>
 127:	00 
 128:	c5 f9 6e df          	vmovd  %edi,%xmm3
 12c:	c4 e2 7d 58 db       	vpbroadcastd %xmm3,%ymm3
 131:	c5 e5 66 d2          	vpcmpgtd %ymm2,%ymm3,%ymm2
 135:	c1 e0 02             	shl    $0x2,%eax
 138:	48 98                	cltq   
 13a:	c4 e2 6d 2c 1c 06    	vmaskmovps (%rsi,%rax,1),%ymm2,%ymm3
 140:	c4 e2 7d 18 c0       	vbroadcastss %xmm0,%ymm0
 145:	c4 e2 7d 18 e9       	vbroadcastss %xmm1,%ymm5
 14a:	c4 e2 7d 18 0d 00 00 	vbroadcastss 0x0(%rip),%ymm1        # 153 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x153>
 151:	00 00 
 153:	c4 e2 65 a8 e9       	vfmadd213ps %ymm1,%ymm3,%ymm5
 158:	c4 e2 7d 18 25 00 00 	vbroadcastss 0x0(%rip),%ymm4        # 161 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x161>
 15f:	00 00 
 161:	c5 d4 54 ec          	vandps %ymm4,%ymm5,%ymm5
 165:	c4 e2 7d 18 35 00 00 	vbroadcastss 0x0(%rip),%ymm6        # 16e <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x16e>
 16c:	00 00 
 16e:	c5 cc c2 fd 01       	vcmpltps %ymm5,%ymm6,%ymm7
 173:	c5 c4 54 fa          	vandps %ymm2,%ymm7,%ymm7
 177:	c5 fc 50 cf          	vmovmskps %ymm7,%ecx
 17b:	85 c9                	test   %ecx,%ecx
 17d:	74 71                	je     1f0 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x1f0>
 17f:	c4 c3 7d 19 f8 01    	vextractf128 $0x1,%ymm7,%xmm8
 185:	c4 c1 41 6b f8       	vpackssdw %xmm8,%xmm7,%xmm7
 18a:	c4 e2 7d 23 ff       	vpmovsxwd %xmm7,%ymm7
 18f:	c4 62 7d 18 05 00 00 	vbroadcastss 0x0(%rip),%ymm8        # 198 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x198>
 196:	00 00 
 198:	c4 62 7d 18 0d 00 00 	vbroadcastss 0x0(%rip),%ymm9        # 1a1 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x1a1>
 19f:	00 00 
 1a1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
 1a8:	0f 1f 84 00 00 00 00 
 1af:	00 
 1b0:	c5 64 59 d0          	vmulps %ymm0,%ymm3,%ymm10
 1b4:	c5 2c 59 d0          	vmulps %ymm0,%ymm10,%ymm10
 1b8:	c5 2c 59 d0          	vmulps %ymm0,%ymm10,%ymm10
 1bc:	c4 42 7d ba d0       	vfmsub231ps %ymm8,%ymm0,%ymm10
 1c1:	c4 41 2c 59 d1       	vmulps %ymm9,%ymm10,%ymm10
 1c6:	c4 c3 7d 4a c2 70    	vblendvps %ymm7,%ymm10,%ymm0,%ymm0
 1cc:	c5 7c 59 d0          	vmulps %ymm0,%ymm0,%ymm10
 1d0:	c4 62 65 a8 d1       	vfmadd213ps %ymm1,%ymm3,%ymm10
 1d5:	c5 2c 54 d4          	vandps %ymm4,%ymm10,%ymm10
 1d9:	c4 c3 55 4a ea 70    	vblendvps %ymm7,%ymm10,%ymm5,%ymm5
 1df:	c5 4c c2 d5 01       	vcmpltps %ymm5,%ymm6,%ymm10
 1e4:	c5 ac 54 ff          	vandps %ymm7,%ymm10,%ymm7
 1e8:	c5 fc 50 cf          	vmovmskps %ymm7,%ecx
 1ec:	85 c9                	test   %ecx,%ecx
 1ee:	75 c0                	jne    1b0 <sqrt_ispc___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x1b0>
 1f0:	c5 e4 59 c0          	vmulps %ymm0,%ymm3,%ymm0
 1f4:	c4 e2 6d 2e 04 02    	vmaskmovps %ymm0,%ymm2,(%rdx,%rax,1)
 1fa:	c5 f8 77             	vzeroupper 
 1fd:	c3                   	retq   
 1fe:	66 90                	xchg   %ax,%ax

0000000000000200 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_>:
 200:	44 8b 07             	mov    (%rdi),%r8d
 203:	8b 77 04             	mov    0x4(%rdi),%esi
 206:	c5 fa 10 47 08       	vmovss 0x8(%rdi),%xmm0
 20b:	48 8b 57 10          	mov    0x10(%rdi),%rdx
 20f:	48 8b 47 18          	mov    0x18(%rdi),%rax
 213:	0f af ce             	imul   %esi,%ecx
 216:	01 ce                	add    %ecx,%esi
 218:	44 39 c6             	cmp    %r8d,%esi
 21b:	41 0f 4d f0          	cmovge %r8d,%esi
 21f:	41 89 f0             	mov    %esi,%r8d
 222:	41 29 c8             	sub    %ecx,%r8d
 225:	41 8d 78 07          	lea    0x7(%r8),%edi
 229:	45 85 c0             	test   %r8d,%r8d
 22c:	41 0f 49 f8          	cmovns %r8d,%edi
 230:	83 e7 f8             	and    $0xfffffff8,%edi
 233:	44 29 c7             	sub    %r8d,%edi
 236:	01 f7                	add    %esi,%edi
 238:	39 f9                	cmp    %edi,%ecx
 23a:	0f 8d fc 00 00 00    	jge    33c <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x13c>
 240:	c4 e2 7d 18 c8       	vbroadcastss %xmm0,%ymm1
 245:	c5 fa 59 d0          	vmulss %xmm0,%xmm0,%xmm2
 249:	c4 e2 7d 18 d2       	vbroadcastss %xmm2,%ymm2
 24e:	48 63 c9             	movslq %ecx,%rcx
 251:	48 63 ff             	movslq %edi,%rdi
 254:	c4 e2 7d 18 1d 00 00 	vbroadcastss 0x0(%rip),%ymm3        # 25d <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x5d>
 25b:	00 00 
 25d:	c4 e2 7d 18 25 00 00 	vbroadcastss 0x0(%rip),%ymm4        # 266 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x66>
 264:	00 00 
 266:	c4 e2 7d 18 2d 00 00 	vbroadcastss 0x0(%rip),%ymm5        # 26f <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x6f>
 26d:	00 00 
 26f:	c4 e2 7d 18 35 00 00 	vbroadcastss 0x0(%rip),%ymm6        # 278 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x78>
 276:	00 00 
 278:	c4 e2 7d 18 3d 00 00 	vbroadcastss 0x0(%rip),%ymm7        # 281 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x81>
 27f:	00 00 
 281:	eb 25                	jmp    2a8 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0xa8>
 283:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
 28a:	84 00 00 00 00 00 
 290:	c4 41 3c 59 c2       	vmulps %ymm10,%ymm8,%ymm8
 295:	c4 21 7c 11 04 00    	vmovups %ymm8,(%rax,%r8,1)
 29b:	48 83 c1 08          	add    $0x8,%rcx
 29f:	48 39 f9             	cmp    %rdi,%rcx
 2a2:	0f 8d 94 00 00 00    	jge    33c <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x13c>
 2a8:	44 8d 04 8d 00 00 00 	lea    0x0(,%rcx,4),%r8d
 2af:	00 
 2b0:	4d 63 c0             	movslq %r8d,%r8
 2b3:	c4 21 7c 10 04 02    	vmovups (%rdx,%r8,1),%ymm8
 2b9:	c4 41 7c 28 d8       	vmovaps %ymm8,%ymm11
 2be:	c4 62 6d a8 db       	vfmadd213ps %ymm3,%ymm2,%ymm11
 2c3:	c5 24 54 cc          	vandps %ymm4,%ymm11,%ymm9
 2c7:	c4 41 54 c2 c9 01    	vcmpltps %ymm9,%ymm5,%ymm9
 2cd:	c4 41 7c 50 c9       	vmovmskps %ymm9,%r9d
 2d2:	c5 7c 28 d1          	vmovaps %ymm1,%ymm10
 2d6:	45 85 c9             	test   %r9d,%r9d
 2d9:	74 b5                	je     290 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x90>
 2db:	c5 24 54 dc          	vandps %ymm4,%ymm11,%ymm11
 2df:	c5 7c 28 d1          	vmovaps %ymm1,%ymm10
 2e3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
 2ea:	84 00 00 00 00 00 
 2f0:	c4 41 3c 59 e2       	vmulps %ymm10,%ymm8,%ymm12
 2f5:	c4 41 2c 59 e4       	vmulps %ymm12,%ymm10,%ymm12
 2fa:	c4 41 2c 59 e4       	vmulps %ymm12,%ymm10,%ymm12
 2ff:	c4 62 2d ba e6       	vfmsub231ps %ymm6,%ymm10,%ymm12
 304:	c5 1c 59 e7          	vmulps %ymm7,%ymm12,%ymm12
 308:	c4 43 2d 4a d4 90    	vblendvps %ymm9,%ymm12,%ymm10,%ymm10
 30e:	c4 41 2c 59 e2       	vmulps %ymm10,%ymm10,%ymm12
 313:	c4 62 3d a8 e3       	vfmadd213ps %ymm3,%ymm8,%ymm12
 318:	c5 1c 54 e4          	vandps %ymm4,%ymm12,%ymm12
 31c:	c4 43 25 4a dc 90    	vblendvps %ymm9,%ymm12,%ymm11,%ymm11
 322:	c4 41 54 c2 e3 01    	vcmpltps %ymm11,%ymm5,%ymm12
 328:	c4 41 1c 54 c9       	vandps %ymm9,%ymm12,%ymm9
 32d:	c4 41 7c 50 c9       	vmovmskps %ymm9,%r9d
 332:	45 85 c9             	test   %r9d,%r9d
 335:	75 b9                	jne    2f0 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0xf0>
 337:	e9 54 ff ff ff       	jmpq   290 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x90>
 33c:	39 f1                	cmp    %esi,%ecx
 33e:	0f 8d e6 00 00 00    	jge    42a <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x22a>
 344:	c5 f9 6e c9          	vmovd  %ecx,%xmm1
 348:	c4 e2 7d 58 c9       	vpbroadcastd %xmm1,%ymm1
 34d:	c5 f5 fe 0d 00 00 00 	vpaddd 0x0(%rip),%ymm1,%ymm1        # 355 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x155>
 354:	00 
 355:	c5 f9 6e d6          	vmovd  %esi,%xmm2
 359:	c4 e2 7d 58 d2       	vpbroadcastd %xmm2,%ymm2
 35e:	c5 ed 66 c9          	vpcmpgtd %ymm1,%ymm2,%ymm1
 362:	c1 e1 02             	shl    $0x2,%ecx
 365:	48 63 c9             	movslq %ecx,%rcx
 368:	c4 e2 75 2c 14 0a    	vmaskmovps (%rdx,%rcx,1),%ymm1,%ymm2
 36e:	c4 e2 7d 18 d8       	vbroadcastss %xmm0,%ymm3
 373:	c5 fa 59 c0          	vmulss %xmm0,%xmm0,%xmm0
 377:	c4 e2 7d 18 e8       	vbroadcastss %xmm0,%ymm5
 37c:	c4 e2 7d 18 05 00 00 	vbroadcastss 0x0(%rip),%ymm0        # 385 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x185>
 383:	00 00 
 385:	c4 e2 6d a8 e8       	vfmadd213ps %ymm0,%ymm2,%ymm5
 38a:	c4 e2 7d 18 25 00 00 	vbroadcastss 0x0(%rip),%ymm4        # 393 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x193>
 391:	00 00 
 393:	c5 d4 54 ec          	vandps %ymm4,%ymm5,%ymm5
 397:	c4 e2 7d 18 35 00 00 	vbroadcastss 0x0(%rip),%ymm6        # 3a0 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x1a0>
 39e:	00 00 
 3a0:	c5 cc c2 fd 01       	vcmpltps %ymm5,%ymm6,%ymm7
 3a5:	c5 c4 54 f9          	vandps %ymm1,%ymm7,%ymm7
 3a9:	c5 fc 50 d7          	vmovmskps %ymm7,%edx
 3ad:	85 d2                	test   %edx,%edx
 3af:	74 6f                	je     420 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x220>
 3b1:	c4 c3 7d 19 f8 01    	vextractf128 $0x1,%ymm7,%xmm8
 3b7:	c4 c1 41 6b f8       	vpackssdw %xmm8,%xmm7,%xmm7
 3bc:	c4 e2 7d 23 ff       	vpmovsxwd %xmm7,%ymm7
 3c1:	c4 62 7d 18 05 00 00 	vbroadcastss 0x0(%rip),%ymm8        # 3ca <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x1ca>
 3c8:	00 00 
 3ca:	c4 62 7d 18 0d 00 00 	vbroadcastss 0x0(%rip),%ymm9        # 3d3 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x1d3>
 3d1:	00 00 
 3d3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
 3da:	84 00 00 00 00 00 
 3e0:	c5 6c 59 d3          	vmulps %ymm3,%ymm2,%ymm10
 3e4:	c5 2c 59 d3          	vmulps %ymm3,%ymm10,%ymm10
 3e8:	c5 2c 59 d3          	vmulps %ymm3,%ymm10,%ymm10
 3ec:	c4 42 65 ba d0       	vfmsub231ps %ymm8,%ymm3,%ymm10
 3f1:	c4 41 2c 59 d1       	vmulps %ymm9,%ymm10,%ymm10
 3f6:	c4 c3 65 4a da 70    	vblendvps %ymm7,%ymm10,%ymm3,%ymm3
 3fc:	c5 64 59 d3          	vmulps %ymm3,%ymm3,%ymm10
 400:	c4 62 6d a8 d0       	vfmadd213ps %ymm0,%ymm2,%ymm10
 405:	c5 2c 54 d4          	vandps %ymm4,%ymm10,%ymm10
 409:	c4 c3 55 4a ea 70    	vblendvps %ymm7,%ymm10,%ymm5,%ymm5
 40f:	c5 4c c2 d5 01       	vcmpltps %ymm5,%ymm6,%ymm10
 414:	c5 ac 54 ff          	vandps %ymm7,%ymm10,%ymm7
 418:	c5 fc 50 d7          	vmovmskps %ymm7,%edx
 41c:	85 d2                	test   %edx,%edx
 41e:	75 c0                	jne    3e0 <sqrt_ispc_task___uniuniunfun_3C_unf_3E_un_3C_unf_3E_+0x1e0>
 420:	c5 ec 59 c3          	vmulps %ymm3,%ymm2,%ymm0
 424:	c4 e2 75 2e 04 08    	vmaskmovps %ymm0,%ymm1,(%rax,%rcx,1)
 42a:	c5 f8 77             	vzeroupper 
 42d:	c3                   	retq   
 42e:	66 90                	xchg   %ax,%ax

0000000000000430 <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_>:
 430:	55                   	push   %rbp
 431:	41 57                	push   %r15
 433:	41 56                	push   %r14
 435:	41 55                	push   %r13
 437:	41 54                	push   %r12
 439:	53                   	push   %rbx
 43a:	48 83 ec 38          	sub    $0x38,%rsp
 43e:	49 89 d6             	mov    %rdx,%r14
 441:	49 89 f7             	mov    %rsi,%r15
 444:	c5 fa 11 44 24 0c    	vmovss %xmm0,0xc(%rsp)
 44a:	41 89 fc             	mov    %edi,%r12d
 44d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
 454:	00 
 455:	c5 fc 11 4c 24 10    	vmovups %ymm1,0x10(%rsp)
 45b:	c5 fc 50 e9          	vmovmskps %ymm1,%ebp
 45f:	45 8d 6c 24 3f       	lea    0x3f(%r12),%r13d
 464:	85 ff                	test   %edi,%edi
 466:	44 0f 49 ef          	cmovns %edi,%r13d
 46a:	41 c1 fd 06          	sar    $0x6,%r13d
 46e:	89 f8                	mov    %edi,%eax
 470:	99                   	cltd   
 471:	41 f7 fd             	idiv   %r13d
 474:	89 c3                	mov    %eax,%ebx
 476:	48 89 e7             	mov    %rsp,%rdi
 479:	be 40 00 00 00       	mov    $0x40,%esi
 47e:	ba 20 00 00 00       	mov    $0x20,%edx
 483:	c5 f8 77             	vzeroupper 
 486:	e8 00 00 00 00       	callq  48b <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x5b>
 48b:	44 89 20             	mov    %r12d,(%rax)
 48e:	44 89 68 04          	mov    %r13d,0x4(%rax)
 492:	c5 f9 6e 44 24 0c    	vmovd  0xc(%rsp),%xmm0
 498:	c5 f9 7e 40 08       	vmovd  %xmm0,0x8(%rax)
 49d:	4c 89 78 10          	mov    %r15,0x10(%rax)
 4a1:	4c 89 70 18          	mov    %r14,0x18(%rax)
 4a5:	81 fd ff 00 00 00    	cmp    $0xff,%ebp
 4ab:	74 08                	je     4b5 <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x85>
 4ad:	c5 fe 6f 44 24 10    	vmovdqu 0x10(%rsp),%ymm0
 4b3:	eb 04                	jmp    4b9 <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x89>
 4b5:	c5 fd 76 c0          	vpcmpeqd %ymm0,%ymm0,%ymm0
 4b9:	c5 fd 7f 40 20       	vmovdqa %ymm0,0x20(%rax)
 4be:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 4c5 <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_+0x95>
 4c5:	48 89 e7             	mov    %rsp,%rdi
 4c8:	48 89 c2             	mov    %rax,%rdx
 4cb:	89 d9                	mov    %ebx,%ecx
 4cd:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 4d3:	41 b9 01 00 00 00    	mov    $0x1,%r9d
 4d9:	c5 f8 77             	vzeroupper 
 4dc:	e8 00 00 00 00       	callq  4e1 <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_+0xb1>
 4e1:	48 8b 3c 24          	mov    (%rsp),%rdi
 4e5:	48 85 ff             	test   %rdi,%rdi
 4e8:	74 05                	je     4ef <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_+0xbf>
 4ea:	e8 00 00 00 00       	callq  4ef <sqrt_ispc_withtasks___uniunfun_3C_unf_3E_un_3C_unf_3E_+0xbf>
 4ef:	48 83 c4 38          	add    $0x38,%rsp
 4f3:	5b                   	pop    %rbx
 4f4:	41 5c                	pop    %r12
 4f6:	41 5d                	pop    %r13
 4f8:	41 5e                	pop    %r14
 4fa:	41 5f                	pop    %r15
 4fc:	5d                   	pop    %rbp
 4fd:	c3                   	retq   
 4fe:	66 90                	xchg   %ax,%ax

0000000000000500 <sqrt_ispc>:
 500:	8d 47 07             	lea    0x7(%rdi),%eax
 503:	85 ff                	test   %edi,%edi
 505:	0f 49 c7             	cmovns %edi,%eax
 508:	c5 fa 59 c8          	vmulss %xmm0,%xmm0,%xmm1
 50c:	83 e0 f8             	and    $0xfffffff8,%eax
 50f:	0f 8e f8 00 00 00    	jle    60d <sqrt_ispc+0x10d>
 515:	c4 e2 7d 18 d0       	vbroadcastss %xmm0,%ymm2
 51a:	c4 e2 7d 18 d9       	vbroadcastss %xmm1,%ymm3
 51f:	89 c1                	mov    %eax,%ecx
 521:	31 c0                	xor    %eax,%eax
 523:	c4 e2 7d 18 25 00 00 	vbroadcastss 0x0(%rip),%ymm4        # 52c <sqrt_ispc+0x2c>
 52a:	00 00 
 52c:	c4 e2 7d 18 2d 00 00 	vbroadcastss 0x0(%rip),%ymm5        # 535 <sqrt_ispc+0x35>
 533:	00 00 
 535:	c4 e2 7d 18 35 00 00 	vbroadcastss 0x0(%rip),%ymm6        # 53e <sqrt_ispc+0x3e>
 53c:	00 00 
 53e:	c4 e2 7d 18 3d 00 00 	vbroadcastss 0x0(%rip),%ymm7        # 547 <sqrt_ispc+0x47>
 545:	00 00 
 547:	c4 62 7d 18 05 00 00 	vbroadcastss 0x0(%rip),%ymm8        # 550 <sqrt_ispc+0x50>
 54e:	00 00 
 550:	eb 26                	jmp    578 <sqrt_ispc+0x78>
 552:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
 559:	1f 84 00 00 00 00 00 
 560:	c4 41 34 59 cb       	vmulps %ymm11,%ymm9,%ymm9
 565:	c4 21 7c 11 0c 02    	vmovups %ymm9,(%rdx,%r8,1)
 56b:	48 83 c0 08          	add    $0x8,%rax
 56f:	48 39 c8             	cmp    %rcx,%rax
 572:	0f 83 97 00 00 00    	jae    60f <sqrt_ispc+0x10f>
 578:	41 89 c0             	mov    %eax,%r8d
 57b:	41 81 e0 f8 ff ff 3f 	and    $0x3ffffff8,%r8d
 582:	49 c1 e0 02          	shl    $0x2,%r8
 586:	c4 21 7c 10 0c 06    	vmovups (%rsi,%r8,1),%ymm9
 58c:	c4 41 7c 28 e1       	vmovaps %ymm9,%ymm12
 591:	c4 62 65 a8 e4       	vfmadd213ps %ymm4,%ymm3,%ymm12
 596:	c5 1c 54 d5          	vandps %ymm5,%ymm12,%ymm10
 59a:	c4 41 4c c2 d2 01    	vcmpltps %ymm10,%ymm6,%ymm10
 5a0:	c4 41 7c 50 ca       	vmovmskps %ymm10,%r9d
 5a5:	c5 7c 28 da          	vmovaps %ymm2,%ymm11
 5a9:	45 85 c9             	test   %r9d,%r9d
 5ac:	74 b2                	je     560 <sqrt_ispc+0x60>
 5ae:	c5 1c 54 e5          	vandps %ymm5,%ymm12,%ymm12
 5b2:	c5 7c 28 da          	vmovaps %ymm2,%ymm11
 5b6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 5bd:	00 00 00 
 5c0:	c4 41 34 59 eb       	vmulps %ymm11,%ymm9,%ymm13
 5c5:	c4 41 24 59 ed       	vmulps %ymm13,%ymm11,%ymm13
 5ca:	c4 41 24 59 ed       	vmulps %ymm13,%ymm11,%ymm13
 5cf:	c4 62 25 ba ef       	vfmsub231ps %ymm7,%ymm11,%ymm13
 5d4:	c4 41 14 59 e8       	vmulps %ymm8,%ymm13,%ymm13
 5d9:	c4 43 25 4a dd a0    	vblendvps %ymm10,%ymm13,%ymm11,%ymm11
 5df:	c4 41 24 59 eb       	vmulps %ymm11,%ymm11,%ymm13
 5e4:	c4 62 35 a8 ec       	vfmadd213ps %ymm4,%ymm9,%ymm13
 5e9:	c5 14 54 ed          	vandps %ymm5,%ymm13,%ymm13
 5ed:	c4 43 1d 4a e5 a0    	vblendvps %ymm10,%ymm13,%ymm12,%ymm12
 5f3:	c4 41 4c c2 ec 01    	vcmpltps %ymm12,%ymm6,%ymm13
 5f9:	c4 41 14 54 d2       	vandps %ymm10,%ymm13,%ymm10
 5fe:	c4 41 7c 50 ca       	vmovmskps %ymm10,%r9d
 603:	45 85 c9             	test   %r9d,%r9d
 606:	75 b8                	jne    5c0 <sqrt_ispc+0xc0>
 608:	e9 53 ff ff ff       	jmpq   560 <sqrt_ispc+0x60>
 60d:	31 c0                	xor    %eax,%eax
 60f:	39 f8                	cmp    %edi,%eax
 611:	0f 8d e3 00 00 00    	jge    6fa <sqrt_ispc+0x1fa>
 617:	c5 f9 6e d0          	vmovd  %eax,%xmm2
 61b:	c4 e2 7d 58 d2       	vpbroadcastd %xmm2,%ymm2
 620:	c5 ed eb 15 00 00 00 	vpor   0x0(%rip),%ymm2,%ymm2        # 628 <sqrt_ispc+0x128>
 627:	00 
 628:	c5 f9 6e df          	vmovd  %edi,%xmm3
 62c:	c4 e2 7d 58 db       	vpbroadcastd %xmm3,%ymm3
 631:	c5 e5 66 d2          	vpcmpgtd %ymm2,%ymm3,%ymm2
 635:	c1 e0 02             	shl    $0x2,%eax
 638:	48 98                	cltq   
 63a:	c4 e2 6d 2c 1c 06    	vmaskmovps (%rsi,%rax,1),%ymm2,%ymm3
 640:	c4 e2 7d 18 c0       	vbroadcastss %xmm0,%ymm0
 645:	c4 e2 7d 18 e9       	vbroadcastss %xmm1,%ymm5
 64a:	c4 e2 7d 18 0d 00 00 	vbroadcastss 0x0(%rip),%ymm1        # 653 <sqrt_ispc+0x153>
 651:	00 00 
 653:	c4 e2 65 a8 e9       	vfmadd213ps %ymm1,%ymm3,%ymm5
 658:	c4 e2 7d 18 25 00 00 	vbroadcastss 0x0(%rip),%ymm4        # 661 <sqrt_ispc+0x161>
 65f:	00 00 
 661:	c5 d4 54 ec          	vandps %ymm4,%ymm5,%ymm5
 665:	c4 e2 7d 18 35 00 00 	vbroadcastss 0x0(%rip),%ymm6        # 66e <sqrt_ispc+0x16e>
 66c:	00 00 
 66e:	c5 cc c2 fd 01       	vcmpltps %ymm5,%ymm6,%ymm7
 673:	c5 c4 54 fa          	vandps %ymm2,%ymm7,%ymm7
 677:	c5 fc 50 cf          	vmovmskps %ymm7,%ecx
 67b:	85 c9                	test   %ecx,%ecx
 67d:	74 71                	je     6f0 <sqrt_ispc+0x1f0>
 67f:	c4 c3 7d 19 f8 01    	vextractf128 $0x1,%ymm7,%xmm8
 685:	c4 c1 41 6b f8       	vpackssdw %xmm8,%xmm7,%xmm7
 68a:	c4 e2 7d 23 ff       	vpmovsxwd %xmm7,%ymm7
 68f:	c4 62 7d 18 05 00 00 	vbroadcastss 0x0(%rip),%ymm8        # 698 <sqrt_ispc+0x198>
 696:	00 00 
 698:	c4 62 7d 18 0d 00 00 	vbroadcastss 0x0(%rip),%ymm9        # 6a1 <sqrt_ispc+0x1a1>
 69f:	00 00 
 6a1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
 6a8:	0f 1f 84 00 00 00 00 
 6af:	00 
 6b0:	c5 64 59 d0          	vmulps %ymm0,%ymm3,%ymm10
 6b4:	c5 2c 59 d0          	vmulps %ymm0,%ymm10,%ymm10
 6b8:	c5 2c 59 d0          	vmulps %ymm0,%ymm10,%ymm10
 6bc:	c4 42 7d ba d0       	vfmsub231ps %ymm8,%ymm0,%ymm10
 6c1:	c4 41 2c 59 d1       	vmulps %ymm9,%ymm10,%ymm10
 6c6:	c4 c3 7d 4a c2 70    	vblendvps %ymm7,%ymm10,%ymm0,%ymm0
 6cc:	c5 7c 59 d0          	vmulps %ymm0,%ymm0,%ymm10
 6d0:	c4 62 65 a8 d1       	vfmadd213ps %ymm1,%ymm3,%ymm10
 6d5:	c5 2c 54 d4          	vandps %ymm4,%ymm10,%ymm10
 6d9:	c4 c3 55 4a ea 70    	vblendvps %ymm7,%ymm10,%ymm5,%ymm5
 6df:	c5 4c c2 d5 01       	vcmpltps %ymm5,%ymm6,%ymm10
 6e4:	c5 ac 54 ff          	vandps %ymm7,%ymm10,%ymm7
 6e8:	c5 fc 50 cf          	vmovmskps %ymm7,%ecx
 6ec:	85 c9                	test   %ecx,%ecx
 6ee:	75 c0                	jne    6b0 <sqrt_ispc+0x1b0>
 6f0:	c5 e4 59 c0          	vmulps %ymm0,%ymm3,%ymm0
 6f4:	c4 e2 6d 2e 04 02    	vmaskmovps %ymm0,%ymm2,(%rdx,%rax,1)
 6fa:	c5 f8 77             	vzeroupper 
 6fd:	c3                   	retq   
 6fe:	66 90                	xchg   %ax,%ax

0000000000000700 <sqrt_ispc_withtasks>:
 700:	55                   	push   %rbp
 701:	41 57                	push   %r15
 703:	41 56                	push   %r14
 705:	41 55                	push   %r13
 707:	41 54                	push   %r12
 709:	53                   	push   %rbx
 70a:	48 83 ec 18          	sub    $0x18,%rsp
 70e:	48 89 d3             	mov    %rdx,%rbx
 711:	49 89 f6             	mov    %rsi,%r14
 714:	c5 fa 11 44 24 0c    	vmovss %xmm0,0xc(%rsp)
 71a:	41 89 ff             	mov    %edi,%r15d
 71d:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
 724:	00 00 
 726:	45 8d 6f 3f          	lea    0x3f(%r15),%r13d
 72a:	85 ff                	test   %edi,%edi
 72c:	44 0f 49 ef          	cmovns %edi,%r13d
 730:	41 c1 fd 06          	sar    $0x6,%r13d
 734:	89 f8                	mov    %edi,%eax
 736:	99                   	cltd   
 737:	41 f7 fd             	idiv   %r13d
 73a:	89 c5                	mov    %eax,%ebp
 73c:	4c 8d 64 24 10       	lea    0x10(%rsp),%r12
 741:	be 40 00 00 00       	mov    $0x40,%esi
 746:	4c 89 e7             	mov    %r12,%rdi
 749:	ba 20 00 00 00       	mov    $0x20,%edx
 74e:	e8 00 00 00 00       	callq  753 <sqrt_ispc_withtasks+0x53>
 753:	44 89 38             	mov    %r15d,(%rax)
 756:	44 89 68 04          	mov    %r13d,0x4(%rax)
 75a:	c5 f9 6e 44 24 0c    	vmovd  0xc(%rsp),%xmm0
 760:	c5 f9 7e 40 08       	vmovd  %xmm0,0x8(%rax)
 765:	4c 89 70 10          	mov    %r14,0x10(%rax)
 769:	48 89 58 18          	mov    %rbx,0x18(%rax)
 76d:	c5 fd 76 c0          	vpcmpeqd %ymm0,%ymm0,%ymm0
 771:	c5 fd 7f 40 20       	vmovdqa %ymm0,0x20(%rax)
 776:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 77d <sqrt_ispc_withtasks+0x7d>
 77d:	4c 89 e7             	mov    %r12,%rdi
 780:	48 89 c2             	mov    %rax,%rdx
 783:	89 e9                	mov    %ebp,%ecx
 785:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 78b:	41 b9 01 00 00 00    	mov    $0x1,%r9d
 791:	c5 f8 77             	vzeroupper 
 794:	e8 00 00 00 00       	callq  799 <sqrt_ispc_withtasks+0x99>
 799:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 79e:	48 85 ff             	test   %rdi,%rdi
 7a1:	74 05                	je     7a8 <sqrt_ispc_withtasks+0xa8>
 7a3:	e8 00 00 00 00       	callq  7a8 <sqrt_ispc_withtasks+0xa8>
 7a8:	48 83 c4 18          	add    $0x18,%rsp
 7ac:	5b                   	pop    %rbx
 7ad:	41 5c                	pop    %r12
 7af:	41 5d                	pop    %r13
 7b1:	41 5e                	pop    %r14
 7b3:	41 5f                	pop    %r15
 7b5:	5d                   	pop    %rbp
 7b6:	c3                   	retq   
