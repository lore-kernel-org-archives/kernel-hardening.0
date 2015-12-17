Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5671B170.1090508@labbott.name>
References: <5671B170.1090508@labbott.name>
Date: Wed, 16 Dec 2015 17:29:14 -0800
Message-ID: <CAGXu5jKKWAVn3Uzjk9n=+GKbPN8hN6Cys_QZQpRc8=AvZWV85Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: multipart/alternative; boundary=001a1140f36a66097f05270df397
Subject: Re: [kernel-hardening] Looking at PAX_MEMORY_SANITIZE
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1140f36a66097f05270df397
Content-Type: text/plain; charset=UTF-8

On Wed, Dec 16, 2015 at 10:46 AM, Laura Abbott <laura@labbott.name> wrote:

> Hi,
>
> I started looking at PAX_MEMORY_SANITIZE for bringing into the kernel. I
> thought
> I would give a short update on what I've found so far for feedback and the
> like.
>
> PAX_MEMORY_SANITIZE is used for clearing both the SL*B allocators and the
> buddy allocator on free. Arguably, similar behavior exists already as debug
> features (SLUB_DEBUG poison, DEBUG_PAGEALLOC for some arches). Given what
> we're
> already finding with features like DEBUG_RODATA though, the sanitization
> really
> needs to be a separate Kconfig not tied to debugging. I debated trying to
> make
> those Kconfigs non-debug but they were tied to other features besides
> poison/
> sanitization.
>

Sounds great! As for CONFIGs, one thing that was request was that we
ultimately put all the hardening configs under a common Kconfig heading so
they can be found easily. I view this as a late-stage tweak, and mostly we
just need to worry about functionality first.

For upstreaming, we'll need a comparison between PAX_MEMORY_SANITIZE and
the existing upstream things that overlap with it.


> I've been focusing my efforts on the SL*B allocators. As it stands, the
> feature
> is fairly self-contained and mostly just needs some refactoring. I plan on
> expanding the command line option to give a bit more control on where the
> sanitization happens. The sanitization currently always happens on the
> fast path
> so my thought was to allow the option of sanitizing only on the slow path.
>

Seems like it should happen on all paths to be a true always-on hardening
feature, though?


> The existing PaX code also disables cache merging. It's not clear if this
> is an
> additional security measure but the sanitization as written doesn't work
> with
> merging. For at least the first version, slab merging will be disabled when
> sanitization is enabled on a slab.
>

That seems fine to me. These trade-offs are to be expected.

Another thing we should call attention to are past bugs and exploits or
exploit methods that would have been hampered or eliminated with this
feature. e.g. How does this play with classic use-after-free, etc?

I'm hoping to post actual patches before I go on vacation for the holidays
> next
> week. Early feedback is appreciated as well if I missed anything.
>

Fantastic! I look forward to testing it. Which gets to a third piece:
adding an lkdtm test for the feature so it's easy to test the kernel's
reaction to the state that is being protected.

Thanks for working on this!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

--001a1140f36a66097f05270df397
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Dec 16, 2015 at 10:46 AM, Laura Abbott <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:laura@labbott.name" target=3D"_blank">laura@labbott.name</a=
>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi,<br>
<br>
I started looking at PAX_MEMORY_SANITIZE for bringing into the kernel. I th=
ought<br>
I would give a short update on what I&#39;ve found so far for feedback and =
the like.<br>
<br>
PAX_MEMORY_SANITIZE is used for clearing both the SL*B allocators and the<b=
r>
buddy allocator on free. Arguably, similar behavior exists already as debug=
<br>
features (SLUB_DEBUG poison, DEBUG_PAGEALLOC for some arches). Given what w=
e&#39;re<br>
already finding with features like DEBUG_RODATA though, the sanitization re=
ally<br>
needs to be a separate Kconfig not tied to debugging. I debated trying to m=
ake<br>
those Kconfigs non-debug but they were tied to other features besides poiso=
n/<br>
sanitization.<br></blockquote><div><br></div><div>Sounds great! As for CONF=
IGs, one thing that was request was that we ultimately put all the hardenin=
g configs under a common Kconfig heading so they can be found easily. I vie=
w this as a late-stage tweak, and mostly we just need to worry about functi=
onality first.</div><div><br></div><div>For upstreaming, we&#39;ll need a c=
omparison between PAX_MEMORY_SANITIZE and the existing upstream things that=
 overlap with it.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
I&#39;ve been focusing my efforts on the SL*B allocators. As it stands, the=
 feature<br>
is fairly self-contained and mostly just needs some refactoring. I plan on<=
br>
expanding the command line option to give a bit more control on where the<b=
r>
sanitization happens. The sanitization currently always happens on the fast=
 path<br>
so my thought was to allow the option of sanitizing only on the slow path.<=
br></blockquote><div><br></div><div>Seems like it should happen on all path=
s to be a true always-on hardening feature, though?</div><div>=C2=A0</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex">
The existing PaX code also disables cache merging. It&#39;s not clear if th=
is is an<br>
additional security measure but the sanitization as written doesn&#39;t wor=
k with<br>
merging. For at least the first version, slab merging will be disabled when=
<br>
sanitization is enabled on a slab.<br></blockquote><div><br></div><div>That=
 seems fine to me. These trade-offs are to be expected.</div><div><br></div=
><div>Another thing we should call attention to are past bugs and exploits =
or exploit methods that would have been hampered or eliminated with this fe=
ature. e.g. How does this play with classic use-after-free, etc?</div><div>=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">
I&#39;m hoping to post actual patches before I go on vacation for the holid=
ays next<br>
week. Early feedback is appreciated as well if I missed anything.<br></bloc=
kquote><div><br></div><div>Fantastic! I look forward to testing it. Which g=
ets to a third piece: adding an lkdtm test for the feature so it&#39;s easy=
 to test the kernel&#39;s reaction to the state that is being protected.</d=
iv><div><br></div><div>Thanks for working on this!</div><div><br></div><div=
>-Kees</div></div><div><br></div>-- <br><div class=3D"gmail_signature">Kees=
 Cook<br>Chrome OS &amp; Brillo Security</div>
</div></div>

--001a1140f36a66097f05270df397--
