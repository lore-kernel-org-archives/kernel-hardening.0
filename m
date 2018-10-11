MIME-Version: 1.0
References: <CALS6=qXmb0sXPbaSS-9ftRidxNSCck-NMxQWpA9AfCWFhwXKwg@mail.gmail.com>
In-Reply-To: <CALS6=qXmb0sXPbaSS-9ftRidxNSCck-NMxQWpA9AfCWFhwXKwg@mail.gmail.com>
From: Carter Cheng <cartercheng@gmail.com>
Date: Fri, 12 Oct 2018 00:38:09 +0800
Message-ID: <CALS6=qUf52a877nH414P0T2B7_9=A6FvqBLc24a-5duX0KrtSQ@mail.gmail.com>
Subject: Fwd: link time analysis for the kernel.
Content-Type: multipart/alternative; boundary="000000000000483b150577f6998c"
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000483b150577f6998c
Content-Type: text/plain; charset="UTF-8"

---------- Forwarded message ---------
From: Carter Cheng <cartercheng@gmail.com>
Date: Thu, Oct 11, 2018 at 9:45 PM
Subject: link time analysis for the kernel.
To: <kernelnewbies@kernelnewbies.org>


Hi,

There are some detaills about the current procedures for linking the kernel
that I am unfamiliar with. My understanding is that GCC and Clang both have
the ability to do link time analysis and transforms on code but is it
possible to write link time passes that will run on the kernel since the
linking phase is a bit different (i.e. doesnt produce an ELF file)?

Are there other tools that are used for the purpose of analysing the kernel
and patching it? I have encountered a tool called Coccinelle but I am
uncertain if CTL can be used to simulate the analysis I would need for
adding and eliding runtime checks on various pointer operations.

I assume from previous discussions that the gcc would be best since clang
still doesn't correctly compile the kernel without patches.

Regards,

Carter.

--000000000000483b150577f6998c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br><div class=3D"gmail_quote"><div dir=3D"ltr">------=
---- Forwarded message ---------<br>From: <strong class=3D"gmail_sendername=
" dir=3D"auto">Carter Cheng</strong> <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:cartercheng@gmail.com">cartercheng@gmail.com</a>&gt;</span><br>Date: Thu,=
 Oct 11, 2018 at 9:45 PM<br>Subject: link time analysis for the kernel.<br>=
To:  &lt;<a href=3D"mailto:kernelnewbies@kernelnewbies.org">kernelnewbies@k=
ernelnewbies.org</a>&gt;<br></div><br><br><div dir=3D"ltr"><div>Hi,</div><d=
iv><br></div>There are some detaills about the current procedures for linki=
ng the kernel that I am unfamiliar with. My understanding is that GCC and C=
lang both have the ability to do link time analysis and transforms on code =
but is it possible to write link time passes that will run on the kernel si=
nce the linking phase is a bit different (i.e. doesnt produce an ELF file)?=
</div><div dir=3D"ltr"><br></div><div>Are there other tools that are used f=
or the purpose of analysing the kernel and patching it? I have encountered =
a tool called=C2=A0<span style=3D"font-family:Calibri;font-size:11pt">Cocci=
nelle but I am uncertain if CTL can be used to simulate the analysis I woul=
d need for adding and eliding runtime checks on various pointer operations.=
</span>=C2=A0</div><div dir=3D"ltr"><br></div><div dir=3D"ltr">I assume fro=
m previous discussions that the gcc would be best since clang still doesn&#=
39;t correctly compile the kernel without patches.=C2=A0<br><div><br></div>=
<div>Regards,</div><div><br></div><div>Carter.</div></div>
</div></div>

--000000000000483b150577f6998c--
