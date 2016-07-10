Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Sun, 10 Jul 2016 21:34:29 +0530
Message-ID: <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a113cfe5cdad1ba05374a3057
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

--001a113cfe5cdad1ba05374a3057
Content-Type: text/plain; charset=UTF-8

Hi Kees,

Sorry for the late reply. I am having some problems with arranging a lot of
mails from the list.

On Wed, Jul 6, 2016 at 11:05 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jul 6, 2016 at 10:40 AM, Shubham Bansal
> <illusionist.neo@gmail.com> wrote:
>> Hi guys,
>>
>> I want to start with linux kernel development and looking for some
project
>> where I can contribute. I was looking at
>> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project which
asked
>> to introduce myself on the list if I am looking for some work (thats
what I
>> am doing :) ). It would be highly appreciated if any of you guys have
>> something where I can contribute.
>>
>> Best,
>> Shubham Bansal
>
> Welcome to the fun! :)
>
> What things are you generally interested in?
Well, I don't have any preference as such. I am open to any work that is
related to security. I have just graduated from the college. I have
background in Crypto, Reverse engg. and exploit development. But if you
need a specific topic, I would say I want to add some features from
grsecurity to main linux kernel.
> Do you have familiarity
> with a specific architecture (or do you want to _gain_ familiarity
> with a specific architecture)?
I have a good familiarity with x86,x86-64 but I also know arm. Although,
its not a problem if there is a need, I will read about it.
>
> There's a small list of stuff that is related to the larger project
> pieces that I try to keep up to date, of varying difficulty:
>
>
http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Specific_TODO_Items

All of these sounds interesting to me. Although I didn't fully understand
some of the TODO items but few of these which I think I would like to work :

   - Move kernel stack to vmap area
   - Split thread_info off of kernel stack
   - Convert remaining BPF JITs to eBPF JIT (with blinding)
   - Write lib/test_bpf.c tests for eBPF constant blinding

But, I can work on other things also, whatever you think is appropriate. I
would prefer working on challenging project though.

Hoping for a quick reply. I want to start working as soon as possible.
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security

Thanks,
Shubham Bansal

--001a113cfe5cdad1ba05374a3057
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi Kees,<br><br></div><div>Sorry for the late re=
ply. I am having some problems with arranging a lot of mails from the list.=
<br></div><div><br>On Wed, Jul 6, 2016 at 11:05 PM, Kees Cook &lt;<a href=
=3D"mailto:keescook@chromium.org">keescook@chromium.org</a>&gt; wrote:<br>&=
gt; On Wed, Jul 6, 2016 at 10:40 AM, Shubham Bansal<br>&gt; &lt;<a href=3D"=
mailto:illusionist.neo@gmail.com">illusionist.neo@gmail.com</a>&gt; wrote:<=
br>&gt;&gt; Hi guys,<br>&gt;&gt;<br>&gt;&gt; I want to start with linux ker=
nel development and looking for some project<br>&gt;&gt; where I can contri=
bute. I was looking at<br>&gt;&gt; <a href=3D"http://kernsec.org/wiki/index=
.php/Kernel_Self_Protection_Project">http://kernsec.org/wiki/index.php/Kern=
el_Self_Protection_Project</a> which asked<br>&gt;&gt; to introduce myself =
on the list if I am looking for some work (thats what I<br>&gt;&gt; am doin=
g :) ). It would be highly appreciated if any of you guys have<br>&gt;&gt; =
something where I can contribute.<br>&gt;&gt;<br>&gt;&gt; Best,<br>&gt;&gt;=
 Shubham Bansal<br>&gt;<br>&gt; Welcome to the fun! :)<br>&gt;<br>&gt; What=
 things are you generally interested in? <br>Well, I don&#39;t have any pre=
ference as such. I am open to any work that is related to security. I have =
just graduated from the college. I have background in Crypto, Reverse engg.=
 and exploit development. But if you need a specific topic, I would say I w=
ant to add some features from grsecurity to main linux kernel.<br>&gt; Do y=
ou have familiarity<br>&gt; with a specific architecture (or do you want to=
 _gain_ familiarity<br>&gt; with a specific architecture)?<br>I have a good=
 familiarity with x86,x86-64 but I also know arm. Although, its not a probl=
em if there is a need, I will read about it.<br>&gt;<br>&gt; There&#39;s a =
small list of stuff that is related to the larger project<br>&gt; pieces th=
at I try to keep up to date, of varying difficulty:<br>&gt;<br>&gt; <a href=
=3D"http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Specif=
ic_TODO_Items">http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Pro=
ject#Specific_TODO_Items</a><br><br>All of these sounds interesting to me. =
Although I didn&#39;t fully understand some of the TODO items but few of th=
ese which I think I would like to work :<br><ul><li> Move kernel stack to v=
map area</li><li>Split thread_info off of kernel stack</li><li>Convert rema=
ining BPF JITs to eBPF JIT (with blinding)
</li><li> Write lib/test_bpf.c tests for eBPF constant blinding
</li></ul><p>But, I can work on other things also, whatever you think is ap=
propriate. I would prefer working on challenging project though.</p><p>Hopi=
ng for a quick reply. I want to start working as soon as possible.<br></p>&=
gt;<br>&gt; -Kees<br>&gt;<br>&gt; --<br>&gt; Kees Cook<br>&gt; Chrome OS &a=
mp; Brillo Security<br><br></div>Thanks,<br></div>Shubham Bansal<br></div>

--001a113cfe5cdad1ba05374a3057--
