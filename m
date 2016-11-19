Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <bf475a29-58cc-7b87-0821-9d23f01851b3@gmail.com>
References: <bf475a29-58cc-7b87-0821-9d23f01851b3@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Sat, 19 Nov 2016 08:36:33 -0800
Message-ID: <CAJcbSZFq_r+bpzyU3VVdukHW3SXsD7EPHkobh7anPVvBgfXtqA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114848308fd7280541aa0627
Subject: Re: [kernel-hardening] get NULL pointer dereferences or #GP fault to
 infomation leakage
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114848308fd7280541aa0627
Content-Type: text/plain; charset=UTF-8

It is an issue because having KASLR enable without panic on oops is not
really useful. Same apply to other mitigations that rely on randomness.

On Sat, Nov 19, 2016 at 3:50 AM, zerons <zeronsaxm@gmail.com> wrote:

> I wonder if this could be an issue.
>
> Test on Ubuntu 16.04 with linux kernel 4.4.x, x86_64.
>
> When a NULL-pointer-deref or a #GP fault
> (e.g: access to 0xdead0000-xxxxxxxx) happens in kernel space,
> it seems that the kernel would kill the current process, then
> output the Oops message or "general protection fault" message.
>
> So we can get these messages via `dmesg` or reading the /var/log/...
>
> I think this may be a way to bypass the KASLR, could it be?
>



-- 
Thomas

--001a114848308fd7280541aa0627
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">It is an issue because having KASLR enable without panic o=
n oops is not really useful. Same apply to other mitigations that rely on r=
andomness.</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">O=
n Sat, Nov 19, 2016 at 3:50 AM, zerons <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:zeronsaxm@gmail.com" target=3D"_blank">zeronsaxm@gmail.com</a>&gt;</spa=
n> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex">I wonder if this could be an is=
sue.<br>
<br>
Test on Ubuntu 16.04 with linux kernel 4.4.x, x86_64.<br>
<br>
When a NULL-pointer-deref or a #GP fault<br>
(e.g: access to 0xdead0000-xxxxxxxx) happens in kernel space,<br>
it seems that the kernel would kill the current process, then<br>
output the Oops message or &quot;general protection fault&quot; message.<br=
>
<br>
So we can get these messages via `dmesg` or reading the /var/log/...<br>
<br>
I think this may be a way to bypass the KASLR, could it be?<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature" data-smartmail=3D"gmail_signature">Thomas</div>
</div>

--001a114848308fd7280541aa0627--
