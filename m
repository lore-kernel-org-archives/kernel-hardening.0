MIME-Version: 1.0
In-Reply-To: <CAGXu5j+FVDAHx9WvUm1uM9OHQLD4FEeToVfB91hJcPBi3udiNw@mail.gmail.com>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
 <CAGXu5jKYMLU1f3bWism+V59cuAeQnm7Fc9zncamq9S8guGR6TQ@mail.gmail.com>
 <CACi5LpNrd+fqOCiA3HnJ6brTCW+v0c1tVPcfFS7Ms0tE0LXmQg@mail.gmail.com> <CAGXu5j+FVDAHx9WvUm1uM9OHQLD4FEeToVfB91hJcPBi3udiNw@mail.gmail.com>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Fri, 3 Feb 2017 01:13:06 +0530
Message-ID: <CACi5LpN0iVg_74YaBR8TEZx8v5jUHG=HBV75R1ROXU5zVpxPZA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a1137be10d7afe40547915f09
Subject: [kernel-hardening] Re: [PATCH 0/2] RFC: Adjust powerpc ASLR elf randomness
To: Kees Cook <keescook@chromium.org>
Cc: Matt Porter <mporter@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Daniel Cashman <dcashman@android.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Alexander Graf <agraf@suse.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, Scott Wood <oss@buserror.net>, Michael Ellerman <mpe@ellerman.id.au>, Anatolij Gustschin <agust@denx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Kumar Gala <galak@kernel.crashing.org>, Alistair Popple <alistair@popple.id.au>, Daniel Cashman <dcashman@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1137be10d7afe40547915f09
Content-Type: text/plain; charset=UTF-8

On 3 Feb 2017 00:49, "Kees Cook" <keescook@chromium.org> wrote:

On Thu, Feb 2, 2017 at 10:08 AM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> On Thu, Feb 2, 2017 at 7:51 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Feb 1, 2017 at 9:42 PM, Bhupesh Sharma <bhsharma@redhat.com>
wrote:
>>> The 2nd patch increases the ELF_ET_DYN_BASE value from the current
>>> hardcoded value of 0x2000_0000 to something more practical,
>>> i.e. TASK_SIZE - PAGE_SHIFT (which makes sense especially for
>>> 64-bit platforms which would like to utilize more randomization
>>> in the load address of a PIE elf).
>>
>> I don't think you want this second patch. Moving ELF_ET_DYN_BASE to
>> the top of TASK_SIZE means you'll be constantly colliding with stack
>> and mmap randomization. 0x20000000 is way better since it randomizes
>> up from there towards the mmap area.
>>
>> Is there a reason to avoid the 32-bit memory range for the ELF addresses?
>
> I think you are right. Hmm, I think I was going by my particular use
> case which might not be required for generic PPC platforms.
>
> I have one doubt though - I have primarily worked on arm64 and x86
> architectures and there I see there 64-bit user space applications
> using the 64-bit load addresses/ranges. I am not sure why PPC64 is
> different historically.

x86's ELF_ET_DYN_BASE is (TASK_SIZE / 3 * 2), so it puts it ET_DYN
base at the top third of the address space. (In theory, this is to
avoid interpreter collisions, but I'm working on removing that
restriction, as it seems pointless.)

Other architectures have small ELF_ET_DYN_BASEs, which is good: it
allows them to have larger entropy for ET_DYN.


Fair enough. I will drop the 2nd patch then and spin a v2.

Regards,
Bhupesh

--001a1137be10d7afe40547915f09
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On 3 Feb 2017 00:49, &quot;Kees Cook&quot; &lt;<a href=3D"mailto:=
keescook@chromium.org">keescook@chromium.org</a>&gt; wrote:<br type=3D"attr=
ibution"><blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left=
:1px #ccc solid;padding-left:1ex"><div class=3D"quoted-text">On Thu, Feb 2,=
 2017 at 10:08 AM, Bhupesh Sharma &lt;<a href=3D"mailto:bhsharma@redhat.com=
">bhsharma@redhat.com</a>&gt; wrote:<br>
&gt; On Thu, Feb 2, 2017 at 7:51 PM, Kees Cook &lt;<a href=3D"mailto:keesco=
ok@chromium.org">keescook@chromium.org</a>&gt; wrote:<br>
&gt;&gt; On Wed, Feb 1, 2017 at 9:42 PM, Bhupesh Sharma &lt;<a href=3D"mail=
to:bhsharma@redhat.com">bhsharma@redhat.com</a>&gt; wrote:<br>
</div><div class=3D"quoted-text">&gt;&gt;&gt; The 2nd patch increases the E=
LF_ET_DYN_BASE value from the current<br>
&gt;&gt;&gt; hardcoded value of 0x2000_0000 to something more practical,<br=
>
&gt;&gt;&gt; i.e. TASK_SIZE - PAGE_SHIFT (which makes sense especially for<=
br>
&gt;&gt;&gt; 64-bit platforms which would like to utilize more randomizatio=
n<br>
&gt;&gt;&gt; in the load address of a PIE elf).<br>
&gt;&gt;<br>
&gt;&gt; I don&#39;t think you want this second patch. Moving ELF_ET_DYN_BA=
SE to<br>
&gt;&gt; the top of TASK_SIZE means you&#39;ll be constantly colliding with=
 stack<br>
&gt;&gt; and mmap randomization. 0x20000000 is way better since it randomiz=
es<br>
&gt;&gt; up from there towards the mmap area.<br>
&gt;&gt;<br>
&gt;&gt; Is there a reason to avoid the 32-bit memory range for the ELF add=
resses?<br>
&gt;<br>
</div><div class=3D"quoted-text">&gt; I think you are right. Hmm, I think I=
 was going by my particular use<br>
&gt; case which might not be required for generic PPC platforms.<br>
&gt;<br>
&gt; I have one doubt though - I have primarily worked on arm64 and x86<br>
&gt; architectures and there I see there 64-bit user space applications<br>
&gt; using the 64-bit load addresses/ranges. I am not sure why PPC64 is<br>
&gt; different historically.<br>
<br>
</div>x86&#39;s ELF_ET_DYN_BASE is (TASK_SIZE / 3 * 2), so it puts it ET_DY=
N<br>
base at the top third of the address space. (In theory, this is to<br>
avoid interpreter collisions, but I&#39;m working on removing that<br>
restriction, as it seems pointless.)<br>
<br>
Other architectures have small ELF_ET_DYN_BASEs, which is good: it<br>
allows them to have larger entropy for ET_DYN.</blockquote></div></div></di=
v><div dir=3D"auto"><br></div><div dir=3D"auto">Fair enough. I will drop th=
e 2nd patch then and spin a v2.</div><div dir=3D"auto"><br></div><div dir=
=3D"auto">Regards,=C2=A0</div><div dir=3D"auto">Bhupesh=C2=A0</div><div dir=
=3D"auto"><div class=3D"gmail_extra"><br></div></div></div>

--001a1137be10d7afe40547915f09--
