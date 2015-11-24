Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Date: Tue, 24 Nov 2015 14:37:41 -0500
Message-ID: <CAEXv5_jnutg89zQLyLCupKf0AOZ=ubdgbJy7AgeeN=7yQicW0A@mail.gmail.com>
From: David Windsor <dave@0x4141.net>
Content-Type: multipart/alternative; boundary=94eb2c061fbe9da6b605254e79bf
Subject: [kernel-hardening] status: PAX_REFCOUNT
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c061fbe9da6b605254e79bf
Content-Type: text/plain; charset=UTF-8

I'm currently in the process of splitting PAX_REFCOUNT.

It looks to touch a massive number of files.  Many of the modifications
occur in drivers:

dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked" | wc -l
402
dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked"
drivers/ | wc -l
158

As it stands, I'm trying to come up with a good way to split the patches.
I'm currently going with a scheme of creating separate patches per kernel
subsystem, further separating by component type (filesystems, drivers,
etc.).  For instance, for patches touching fs/, I've created a patch for
filesystem-independent changes, then separate patches for each individual
filesystem's changes.  Extrapolated over the entire kernel, I estimate this
strategy will produce approximately between 50 and 75 patches.

I'm moving my way through the tree and will hopefully have an RFC
submission soon.

Thanks,
David Windsor

--94eb2c061fbe9da6b605254e79bf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I&#39;m currently in the process of splitting PAX_REF=
COUNT.=C2=A0 <br><br></div>It looks to touch a massive number of files.=C2=
=A0 Many of the modifications occur in drivers:<br><br><div><div>dave@stron=
tium:~/src/linux-grsec-4.2$ grep -ril &quot;atomic.*unchecked&quot; | wc -l=
</div><div>402</div><div>dave@strontium:~/src/linux-grsec-4.2$ grep -ril &q=
uot;atomic.*unchecked&quot; drivers/ | wc -l</div><div>158<br><br></div><di=
v>As it stands, I&#39;m trying to come up with a good way to split the patc=
hes.=C2=A0 I&#39;m currently going with a scheme of creating separate patch=
es per kernel subsystem, further separating by component type (filesystems,=
 drivers, etc.).=C2=A0 For instance, for patches touching fs/, I&#39;ve cre=
ated a patch for filesystem-independent changes, then separate patches for =
each individual filesystem&#39;s changes.=C2=A0 Extrapolated over the entir=
e kernel, I estimate this strategy will produce approximately between 50 an=
d 75 patches.=C2=A0 <br><br></div><div>I&#39;m moving my way through the tr=
ee and will hopefully have an RFC submission soon.<br></div><div><br></div>=
<div>Thanks,<br></div><div>David Windsor<br></div></div><br><br><br></div>

--94eb2c061fbe9da6b605254e79bf--
