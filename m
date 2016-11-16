Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: Gengjia Chen <chengjia4574@gmail.com>
Date: Wed, 16 Nov 2016 22:39:38 +0800
Message-ID: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11408008f589f105416c0a25
Subject: [kernel-hardening] patches for __write_rarely section
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11408008f589f105416c0a25
Content-Type: text/plain; charset=UTF-8

Hello kees and everyone :

This email introduces two patches.

Patch 1 introduce the write-rarely memory section for
those kernel objects which are read only mostly
but need to be written to sometimes.

Patch 2 introduce two helper functions (mark_wrdata_rw/
mark_wrdata_ro) to make __write_rarely memory section
writable or unwritable. They play like the pax_open_kernel/
pax_close_kernel functions in grsecurity patch.Right now
this only been implemented on arm32.

These two patches were based on the work by PaxTeam and Grsecurity.
These two patched were based on https://github.com/torvalds/linux.git :
27bcd37e0240bbe33f0efe244b5aad52104115b3

By the way, I am a new recruit for kernel coding so I hope that
someone can review these patches and tell me what to do next.
Also, I am working on the implement of mark_wrdata_rw/mark_wrdata_ro
on aarch64, any advice about that would be appreciated.

==== patch 1 =====

>From 7ee1ed5a723723112167ca8603f4e2945d133b33 Mon Sep 17 00:00:00 2001
From: chengengjia <chengjia4574@gmail.com>
Date: Wed, 16 Nov 2016 21:46:49 +0800
Subject: [PATCH] arch: introduce write-rarely memory section

This introduces __write_rarely section as a way
to mark those memory that read only in most case,
but also need to be written to sometimes.

Signed-off-by: chengengjia <chengjia4574@gmail.com>
---
 include/asm-generic/vmlinux.lds.h | 9 +++++++++
 include/linux/cache.h             | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h
b/include/asm-generic/vmlinux.lds.h
index 3074796..684bcf2 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -263,6 +263,14 @@
 #endif

 /*
+ * Allow architectures to handle write_rarely data on their
+ * own by defining an empty WRITE_RARELY_DATA.
+ */
+#ifndef WRITE_RARELY_DATA
+#define WRITE_RARELY_DATA *(.data..write_rarely)
+#endif
+
+/*
  * Read only Data
  */
 #define RO_DATA_SECTION(align) \
@@ -271,6 +279,7 @@
  VMLINUX_SYMBOL(__start_rodata) = .; \
  *(.rodata) *(.rodata.*) \
  RO_AFTER_INIT_DATA /* Read only after init */ \
+ WRITE_RARELY_DATA /* write rarely*/ \
  *(__vermagic) /* Kernel version magic */ \
  . = ALIGN(8); \
  VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .; \
diff --git a/include/linux/cache.h b/include/linux/cache.h
index 1be04f8..d2c30cd 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -30,6 +30,15 @@
 #define __ro_after_init
__attribute__((__section__(".data..ro_after_init")))
 #endif

+/*
+ * __write_rarely is used to mark things that are read-only mostly but
need to be
+ * written to sometimes. To write to __write_rarely variables,
mark_wrdata_rw()
+ * need to be called, after write, mark_wrdata_ro() should be called.
+ */
+#ifndef __write_rarely
+#define __write_rarely __attribute__((__section__(".data..write_rarely")))
+#endif
+
 #ifndef ____cacheline_aligned
 #define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
 #endif
-- 
1.9.1


==== patch 2 =====

>From 0472f3f14532577a1963d517da8a0edfe1d99375 Mon Sep 17 00:00:00 2001
From: chengengjia <chengjia4574@gmail.com>
Date: Wed, 16 Nov 2016 22:16:43 +0800
Subject: [PATCH] arch: arm: add mark_wrdata_rw/mark_wrdata_ro functions

This introduces mark_wrdata_rw/mark_wrdata_ro to
mark __write_rarely section writable/unwritable.
Based on work by PaxTeam and Grsecurity.

Signed-off-by: chengengjia <chengjia4574@gmail.com>
---
 arch/arm/include/asm/domain.h  | 14 ++++++++++++++
 arch/arm/include/asm/pgtable.h | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index 99d9f63..01f18a5 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -54,6 +54,10 @@
 #else
 #define DOMAIN_MANAGER 1
 #endif
+#ifdef  CONFIG_DEBUG_RODATA
+#define DOMAIN_OPENKERN 3
+#endif
+

 #define domain_mask(dom) ((3) << (2 * (dom)))
 #define domain_val(dom,type) ((type) << (2 * (dom)))
@@ -124,6 +128,16 @@ static inline void set_domain(unsigned val)
  set_domain(domain); \
  } while (0)

+#elif defined(CONFIG_DEBUG_RODATA)
+#define modify_domain(dom,type)                                 \
+        do {                                                    \
+                struct thread_info *thread = current_thread_info(); \
+                unsigned int domain = get_domain();             \
+                domain &= ~domain_mask(dom);                    \
+                domain = domain | domain_val(dom, type);        \
+                thread->cpu_domain = domain;                    \
+                set_domain(domain);                             \
+        } while (0)
 #else
 static inline void modify_domain(unsigned dom, unsigned type) { }
 #endif
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index a8d656d..5e6f553 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -56,6 +56,44 @@
 #define pmd_ERROR(pmd) __pmd_error(__FILE__, __LINE__, pmd)
 #define pgd_ERROR(pgd) __pgd_error(__FILE__, __LINE__, pgd)

+#ifdef  CONFIG_DEBUG_RODATA
+#include <asm/domain.h>
+#include <linux/thread_info.h>
+#include <linux/preempt.h>
+
+static inline int test_domain(int domain, int domaintype)
+{
+        return ((current_thread_info()->cpu_domain) & domain_val(domain,
3))
+ == domain_val(domain, domaintype);
+}
+
+static inline unsigned long mark_wrdata_rw(void) {
+#ifdef CONFIG_ARM_LPAE
+        /* TODO */
+#else
+        preempt_disable();
+        BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_OPENKERN));
+        modify_domain(DOMAIN_KERNEL, DOMAIN_OPENKERN);
+#endif
+        return 0;
+}
+
+static inline unsigned long mark_wrdata_ro(void) {
+#ifdef CONFIG_ARM_LPAE
+        /* TODO */
+#else
+        BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_MANAGER));
+        modify_domain(DOMAIN_KERNEL, DOMAIN_MANAGER);
+        preempt_enable_no_resched();
+#endif
+        return 0;
+}
+#else
+static inline unsigned long mark_wrdata_rw(void) { return 0; }
+static inline unsigned long mark_wrdata_ro(void) { return 0; }
+#endif
+
+
 /*
  * This is the lowest virtual address we can permit any user space
  * mapping to be mapped at.  This is particularly important for
-- 
1.9.1


=====

--001a11408008f589f105416c0a25
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello kees and everyone :<div><br></div><div>This email in=
troduces two patches.</div><div><br></div><div>Patch 1 introduce the write-=
rarely memory section for</div><div>those kernel objects which are read onl=
y mostly=C2=A0</div><div>but need to be written to sometimes.</div><div><br=
></div><div>Patch 2 introduce two helper functions (mark_wrdata_rw/</div><d=
iv>mark_wrdata_ro) to make __write_rarely memory section</div><div>writable=
 or unwritable. They play like the pax_open_kernel/</div><div>pax_close_ker=
nel functions in grsecurity patch.Right now=C2=A0</div><div>this only been =
implemented on arm32.</div><div><br></div><div>These two patches were based=
 on the work by PaxTeam and Grsecurity.</div><div><div>These two patched we=
re based on <a href=3D"https://github.com/torvalds/linux.git">https://githu=
b.com/torvalds/linux.git</a> :=C2=A0</div><div>27bcd37e0240bbe33f0efe244b5a=
ad52104115b3</div></div><div><br></div><div>By the way, I am a new recruit =
for kernel coding so I hope that=C2=A0</div><div>someone can review these p=
atches and tell me what to do next.</div><div>Also, I am working on the imp=
lement of mark_wrdata_rw/mark_wrdata_ro</div><div>on aarch64, any advice ab=
out that would be appreciated.</div><div><br></div><div>=3D=3D=3D=3D patch =
1 =3D=3D=3D=3D=3D<br></div><div><br></div><div><div>From 7ee1ed5a7237231121=
67ca8603f4e2945d133b33 Mon Sep 17 00:00:00 2001</div><div>From: chengengjia=
 &lt;<a href=3D"mailto:chengjia4574@gmail.com">chengjia4574@gmail.com</a>&g=
t;</div><div>Date: Wed, 16 Nov 2016 21:46:49 +0800</div><div>Subject: [PATC=
H] arch: introduce write-rarely memory section</div><div><br></div><div>Thi=
s introduces __write_rarely section as a way</div><div>to mark those memory=
 that read only in most case,</div><div>but also need to be written to some=
times.</div><div><br></div><div>Signed-off-by: chengengjia &lt;<a href=3D"m=
ailto:chengjia4574@gmail.com">chengjia4574@gmail.com</a>&gt;</div><div>---<=
/div><div>=C2=A0include/asm-generic/vmlinux.lds.h | 9 +++++++++</div><div>=
=C2=A0include/linux/cache.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 9 +=
++++++++</div><div>=C2=A02 files changed, 18 insertions(+)</div><div><br></=
div><div>diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-gener=
ic/vmlinux.lds.h</div><div>index 3074796..684bcf2 100644</div><div>--- a/in=
clude/asm-generic/vmlinux.lds.h</div><div>+++ b/include/asm-generic/vmlinux=
.lds.h</div><div>@@ -263,6 +263,14 @@</div><div>=C2=A0#endif</div><div>=C2=
=A0</div><div>=C2=A0/*</div><div>+ * Allow architectures to handle write_ra=
rely data on their</div><div>+ * own by defining an empty WRITE_RARELY_DATA=
.</div><div>+ */</div><div>+#ifndef WRITE_RARELY_DATA</div><div>+#define WR=
ITE_RARELY_DATA *(.data..write_rarely)</div><div>+#endif</div><div>+</div><=
div>+/*</div><div>=C2=A0 * Read only Data</div><div>=C2=A0 */</div><div>=C2=
=A0#define RO_DATA_SECTION(align)<span class=3D"gmail-Apple-tab-span" style=
=3D"white-space:pre">						</span>\</div><div>@@ -271,6 +279,7 @@</div><div=
>=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">		</s=
pan>VMLINUX_SYMBOL(__start_rodata) =3D .;<span class=3D"gmail-Apple-tab-spa=
n" style=3D"white-space:pre">			</span>\</div><div>=C2=A0<span class=3D"gma=
il-Apple-tab-span" style=3D"white-space:pre">		</span>*(.rodata) *(.rodata.=
*)<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">					</spa=
n>\</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-spa=
ce:pre">		</span>RO_AFTER_INIT_DATA<span class=3D"gmail-Apple-tab-span" sty=
le=3D"white-space:pre">	</span>/* Read only after init */<span class=3D"gma=
il-Apple-tab-span" style=3D"white-space:pre">	</span>\</div><div>+<span cla=
ss=3D"gmail-Apple-tab-span" style=3D"white-space:pre">		</span>WRITE_RARELY=
_DATA<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span=
>/* write rarely*/<span class=3D"gmail-Apple-tab-span" style=3D"white-space=
:pre">		</span>\</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" style=
=3D"white-space:pre">		</span>*(__vermagic)<span class=3D"gmail-Apple-tab-s=
pan" style=3D"white-space:pre">		</span>/* Kernel version magic */<span cla=
ss=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span>\</div><div>=
=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">		</sp=
an>. =3D ALIGN(8);<span class=3D"gmail-Apple-tab-span" style=3D"white-space=
:pre">						</span>\</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" s=
tyle=3D"white-space:pre">		</span>VMLINUX_SYMBOL(__start___tracepoints_ptrs=
) =3D .;<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">		</=
span>\</div><div>diff --git a/include/linux/cache.h b/include/linux/cache.h=
</div><div>index 1be04f8..d2c30cd 100644</div><div>--- a/include/linux/cach=
e.h</div><div>+++ b/include/linux/cache.h</div><div>@@ -30,6 +30,15 @@</div=
><div>=C2=A0#define __ro_after_init __attribute__((__section__(&quot;.data.=
.ro_after_init&quot;)))</div><div>=C2=A0#endif</div><div>=C2=A0</div><div>+=
/*</div><div>+ * __write_rarely is used to mark things that are read-only m=
ostly but need to be</div><div>+ * written to sometimes. To write to __writ=
e_rarely variables, mark_wrdata_rw()</div><div>+ * need to be called, after=
 write, mark_wrdata_ro() should be called.</div><div>+ */</div><div>+#ifnde=
f __write_rarely</div><div>+#define __write_rarely __attribute__((__section=
__(&quot;.data..write_rarely&quot;)))</div><div>+#endif</div><div>+</div><d=
iv>=C2=A0#ifndef ____cacheline_aligned</div><div>=C2=A0#define ____cachelin=
e_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))</div><div>=C2=A0#en=
dif</div><div>--=C2=A0</div><div>1.9.1</div></div><div><br></div><div><br><=
/div><div>=3D=3D=3D=3D patch 2 =3D=3D=3D=3D=3D</div><div><br></div><div><di=
v>From 0472f3f14532577a1963d517da8a0edfe1d99375 Mon Sep 17 00:00:00 2001</d=
iv><div>From: chengengjia &lt;<a href=3D"mailto:chengjia4574@gmail.com">che=
ngjia4574@gmail.com</a>&gt;</div><div>Date: Wed, 16 Nov 2016 22:16:43 +0800=
</div><div>Subject: [PATCH] arch: arm: add mark_wrdata_rw/mark_wrdata_ro fu=
nctions</div><div><br></div><div>This introduces mark_wrdata_rw/mark_wrdata=
_ro to</div><div>mark __write_rarely section writable/unwritable.</div><div=
>Based on work by PaxTeam and Grsecurity.</div><div><br></div><div>Signed-o=
ff-by: chengengjia &lt;<a href=3D"mailto:chengjia4574@gmail.com">chengjia45=
74@gmail.com</a>&gt;</div><div>---</div><div>=C2=A0arch/arm/include/asm/dom=
ain.h =C2=A0| 14 ++++++++++++++</div><div>=C2=A0arch/arm/include/asm/pgtabl=
e.h | 38 ++++++++++++++++++++++++++++++++++++++</div><div>=C2=A02 files cha=
nged, 52 insertions(+)</div><div><br></div><div>diff --git a/arch/arm/inclu=
de/asm/domain.h b/arch/arm/include/asm/domain.h</div><div>index 99d9f63..01=
f18a5 100644</div><div>--- a/arch/arm/include/asm/domain.h</div><div>+++ b/=
arch/arm/include/asm/domain.h</div><div>@@ -54,6 +54,10 @@</div><div>=C2=A0=
#else</div><div>=C2=A0#define DOMAIN_MANAGER<span class=3D"gmail-Apple-tab-=
span" style=3D"white-space:pre">	</span>1</div><div>=C2=A0#endif</div><div>=
+#ifdef =C2=A0CONFIG_DEBUG_RODATA</div><div>+#define DOMAIN_OPENKERN 3</div=
><div>+#endif</div><div>+</div><div>=C2=A0</div><div>=C2=A0#define domain_m=
ask(dom)<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</s=
pan>((3) &lt;&lt; (2 * (dom)))</div><div>=C2=A0#define domain_val(dom,type)=
<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span>((ty=
pe) &lt;&lt; (2 * (dom)))</div><div>@@ -124,6 +128,16 @@ static inline void=
 set_domain(unsigned val)</div><div>=C2=A0<span class=3D"gmail-Apple-tab-sp=
an" style=3D"white-space:pre">		</span>set_domain(domain);<span class=3D"gm=
ail-Apple-tab-span" style=3D"white-space:pre">				</span>\</div><div>=C2=A0=
<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span>} wh=
ile (0)</div><div>=C2=A0</div><div>+#elif defined(CONFIG_DEBUG_RODATA)</div=
><div>+#define modify_domain(dom,type) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0do { =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0\</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0struct thread_info *thread =3D current_thread_info(); \</div><div>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int domain =
=3D get_domain(); =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \</div><div>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0domain &amp;=3D ~dom=
ain_mask(dom); =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0\</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0domain =3D domain | domain_val(dom, type); =C2=A0 =C2=A0 =C2=A0 =C2=
=A0\</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thr=
ead-&gt;cpu_domain =3D domain; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0\</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0set_domain(domain); =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \</div><div=
>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0} while (0)</div><div>=C2=A0#else</div><div>=
=C2=A0static inline void modify_domain(unsigned dom, unsigned type)<span cl=
ass=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span>{ }</div><di=
v>=C2=A0#endif</div><div>diff --git a/arch/arm/include/asm/pgtable.h b/arch=
/arm/include/asm/pgtable.h</div><div>index a8d656d..5e6f553 100644</div><di=
v>--- a/arch/arm/include/asm/pgtable.h</div><div>+++ b/arch/arm/include/asm=
/pgtable.h</div><div>@@ -56,6 +56,44 @@</div><div>=C2=A0#define pmd_ERROR(p=
md)<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">		</span>=
__pmd_error(__FILE__, __LINE__, pmd)</div><div>=C2=A0#define pgd_ERROR(pgd)=
<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">		</span>__p=
gd_error(__FILE__, __LINE__, pgd)</div><div>=C2=A0</div><div>+#ifdef =C2=A0=
CONFIG_DEBUG_RODATA</div><div>+#include &lt;asm/domain.h&gt;</div><div>+#in=
clude &lt;linux/thread_info.h&gt;</div><div>+#include &lt;linux/preempt.h&g=
t;</div><div>+</div><div>+static inline int test_domain(int domain, int dom=
aintype)</div><div>+{</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0return ((curre=
nt_thread_info()-&gt;cpu_domain) &amp; domain_val(domain, 3))=C2=A0</div><d=
iv>+<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">			</spa=
n>=3D=3D domain_val(domain, domaintype);</div><div>+}</div><div>+</div><div=
>+static inline unsigned long mark_wrdata_rw(void) {</div><div>+#ifdef CONF=
IG_ARM_LPAE</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0/* TODO */</div><div>+#e=
lse</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0preempt_disable();</div><div>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_OPENKER=
N));</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0modify_domain(DOMAIN_KERNEL, DO=
MAIN_OPENKERN);</div><div>+#endif</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0re=
turn 0;</div><div>+}</div><div>+</div><div>+static inline unsigned long mar=
k_wrdata_ro(void) {</div><div>+#ifdef CONFIG_ARM_LPAE</div><div>+ =C2=A0 =
=C2=A0 =C2=A0 =C2=A0/* TODO */</div><div>+#else</div><div>+ =C2=A0 =C2=A0 =
=C2=A0 =C2=A0BUG_ON(test_domain(DOMAIN_KERNEL, DOMAIN_MANAGER));</div><div>=
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0modify_domain(DOMAIN_KERNEL, DOMAIN_MANAGER);<=
/div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0preempt_enable_no_resched();</div><d=
iv>+#endif</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;</div><div>+}</d=
iv><div>+#else</div><div>+static inline unsigned long mark_wrdata_rw(void) =
{ return 0; }</div><div>+static inline unsigned long mark_wrdata_ro(void) {=
 return 0; }</div><div>+#endif</div><div>+</div><div>+</div><div>=C2=A0/*</=
div><div>=C2=A0 * This is the lowest virtual address we can permit any user=
 space</div><div>=C2=A0 * mapping to be mapped at.=C2=A0 This is particular=
ly important for</div><div>--=C2=A0</div><div>1.9.1</div></div><div><br></d=
iv><div><br></div><div>=3D=3D=3D=3D=3D</div><div><br></div></div>

--001a11408008f589f105416c0a25--
