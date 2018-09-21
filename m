MIME-Version: 1.0
From: Carter Cheng <cartercheng@gmail.com>
Date: Sat, 22 Sep 2018 01:25:48 +0800
Message-ID: <CALS6=qVgYYxcjv8Fj4pdPJ0Z_fUceTV60DtKwOhFkSz4HZohxg@mail.gmail.com>
Subject: temporal and spatial locality in the kernel
Content-Type: multipart/alternative; boundary="000000000000d3b9e0057664eedb"
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000d3b9e0057664eedb
Content-Type: text/plain; charset="UTF-8"

Hi,

I recently attended a computer security conference for the first time and
have developed some interest in kernel hardening issues after one of the
presenters demonstrated a kernel exploit based partly around a use after
free bug.

After scanning the literature a little bit and looking at some papers I
have encountered before on CCured and Cyclone. I was curious to what extent
full memory saftety checks are now possible.

There are many papers going back quite a bit on spatial safety
implementations and some on temporal safety but they mainly target user
space. I am curious why such things don't exist in the linux kernel at
least as some sort of compile option. Is the slow down the main concern?

It seems recent work has got the performance bound down to 1.29 is this
considered too slow for many things?

Regards,

Carter

--000000000000d3b9e0057664eedb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I recently attended a computer secu=
rity conference for the first time and have developed some interest in kern=
el hardening issues after one of the presenters demonstrated a kernel explo=
it based partly around a use after free bug.=C2=A0</div><div><br></div><div=
>After scanning the literature a little bit and looking at some papers I ha=
ve encountered before on CCured and Cyclone. I was curious to what extent f=
ull memory saftety checks are now possible.=C2=A0</div><div><br></div><div>=
There are many papers going back quite a bit on spatial safety implementati=
ons and some on temporal safety but they mainly target user space. I am cur=
ious why such things don&#39;t exist in the linux kernel at least as some s=
ort of compile option. Is the slow down the main concern?</div><div><br></d=
iv><div>It seems recent work has got the performance bound down to 1.29 is =
this considered too slow for many things?</div><div><br></div><div>Regards,=
</div><div><br></div><div>Carter=C2=A0</div></div>

--000000000000d3b9e0057664eedb--
