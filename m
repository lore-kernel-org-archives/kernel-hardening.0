Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20130406101037.GA3612@pd.tnic>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<20130405144954.GC29290@pd.tnic>
	<CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
	<20130405204306.GA14092@pd.tnic>
	<CAGXu5jJtBgUXwMm6D=JnUvP3kv6YN2MwaF81-2GC-d+pJJFy6w@mail.gmail.com>
	<20130406101037.GA3612@pd.tnic>
Date: Mon, 8 Apr 2013 08:34:59 +0300
Message-ID: <CAH6MLePbvwU-8KBWo5h4k13_=K6EQZdSmBpQ+Bm8u3kV9b2dYQ@mail.gmail.com>
From: Hasinoliva MIARIMANJATO <hasinoliva@gmail.com>
Content-Type: multipart/alternative; boundary=e89a8f3bb03d3317f604d9d2cc8b
Subject: Re: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: kernel-hardening@lists.openwall.com, Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@google.com>, LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

--e89a8f3bb03d3317f604d9d2cc8b
Content-Type: text/plain; charset=ISO-8859-1

Hi i want to get so more information about pohmelfs ; i want to get
pohmelfs server and pohmelfs client that i don't find it in the internet ,
please help me

 thank you.


2013/4/6 Borislav Petkov <bp@alien8.de>

> On Fri, Apr 05, 2013 at 04:18:49PM -0700, Kees Cook wrote:
> > There is already a hook in the patch that prints the offset:
> >
> > +dump_kernel_offset(struct notifier_block *self, unsigned long v, void
> *p)
> > +{
> > +       pr_emerg("Kernel Offset: 0x%lx\n",
> > +                (unsigned long)&_text - __START_KERNEL);
> > ...
> > +       atomic_notifier_chain_register(&panic_notifier_list,
> > +                                       &kernel_offset_notifier);
> >
> > But of course, this can get improved.
>
> Yeah, this should probably be added to dump_trace(), i.e. something
> which walks stack frames and dumps addresses. Because, in the panic
> notifier, you're missing all those WARN* callsites, for example.
>
> Also, I wonder whether it wouldn't be too hard to go even a step further
> and compute the original, linker vmlinux addresses from the offsets
> and dump a stack trace which looks exactly the same as if KASLR is
> off. It'll probably need something to say KASLR was on when the trace
> happened, though:
>
> [  790.253365] Call Trace (KASLR):
> [  790.254121]  [<ffffffff8110bc90>] ? __smpboot_create_thread+0x180/0x180
> [  790.255428]  [<ffffffff810ff1df>] kthread+0xef/0x100
> ...
>
> so that people who stare at this, know.
>
> Because, in that case, you don't need both the panic notifier or the
> userspace script massaging stack trace output anymore.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
>

--e89a8f3bb03d3317f604d9d2cc8b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi i want to get so more information about pohmelfs ;=
 i want to get
 pohmelfs server and pohmelfs client that i don&#39;t find it in the=20
internet , please help me <br>
<br>
</div>
thank you.</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quot=
e">2013/4/6 Borislav Petkov <span dir=3D"ltr">&lt;<a href=3D"mailto:bp@alie=
n8.de" target=3D"_blank">bp@alien8.de</a>&gt;</span><br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"im">On Fri, Apr 05, 2013 at 04:18:49PM -0700, Kees Cook wrote=
:<br>
&gt; There is already a hook in the patch that prints the offset:<br>
&gt;<br>
&gt; +dump_kernel_offset(struct notifier_block *self, unsigned long v, void=
 *p)<br>
&gt; +{<br>
&gt; + =A0 =A0 =A0 pr_emerg(&quot;Kernel Offset: 0x%lx\n&quot;,<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long)&amp;_text - __START_K=
ERNEL);<br>
&gt; ...<br>
&gt; + =A0 =A0 =A0 atomic_notifier_chain_register(&amp;panic_notifier_list,=
<br>
&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 &amp;kernel_offset_notifier);<br>
&gt;<br>
&gt; But of course, this can get improved.<br>
<br>
</div>Yeah, this should probably be added to dump_trace(), i.e. something<b=
r>
which walks stack frames and dumps addresses. Because, in the panic<br>
notifier, you&#39;re missing all those WARN* callsites, for example.<br>
<br>
Also, I wonder whether it wouldn&#39;t be too hard to go even a step furthe=
r<br>
and compute the original, linker vmlinux addresses from the offsets<br>
and dump a stack trace which looks exactly the same as if KASLR is<br>
off. It&#39;ll probably need something to say KASLR was on when the trace<b=
r>
happened, though:<br>
<br>
[ =A0790.253365] Call Trace (KASLR):<br>
[ =A0790.254121] =A0[&lt;ffffffff8110bc90&gt;] ? __smpboot_create_thread+0x=
180/0x180<br>
[ =A0790.255428] =A0[&lt;ffffffff810ff1df&gt;] kthread+0xef/0x100<br>
...<br>
<br>
so that people who stare at this, know.<br>
<br>
Because, in that case, you don&#39;t need both the panic notifier or the<br=
>
userspace script massaging stack trace output anymore.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
Regards/Gruss,<br>
=A0 =A0 Boris.<br>
<br>
Sent from a fat crate under my desk. Formatting is fine.<br>
--<br>
</div></div></blockquote></div><br></div>

--e89a8f3bb03d3317f604d9d2cc8b--
