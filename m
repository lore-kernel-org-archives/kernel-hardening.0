MIME-Version: 1.0
From: Carter Cheng <cartercheng@gmail.com>
Date: Thu, 6 Dec 2018 04:46:15 +0800
Message-ID: <CALS6=qX5TyXFjVnJiamaBhVrfLa0_LYkjH9iN2-WKpVwM0WnGA@mail.gmail.com>
Subject: dynamically allocating memory in the kernel
Content-Type: multipart/alternative; boundary="000000000000d6efa0057c4c79e0"
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000d6efa0057c4c79e0
Content-Type: text/plain; charset="UTF-8"

Hello,

I was wondering if someone here could help me understand something about
the kernel for a project I am working on tracking dynamically allocated
memory. How many ways are there to dynamically allocate memory in the
kernel presently? I know of 4.

get_free_pages family of functions
kmalloc family (including vmalloc)
slab allocation
mempools.

Are there others? I am trying to track them all down so I have
comprehensively know when all allocations occur and all "frees".

Thanks for your help,

Carter.

--000000000000d6efa0057c4c79e0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>I was wondering if someone here =
could help me understand something about the kernel for a project I am work=
ing on tracking dynamically allocated memory. How many ways are there to dy=
namically allocate memory in the kernel presently? I know of 4.</div><div><=
br></div><div>get_free_pages family of functions</div><div>kmalloc family (=
including vmalloc)</div><div>slab allocation</div><div>mempools.</div><div>=
<br></div><div>Are there others? I am trying to track them all down so I ha=
ve comprehensively know when all allocations occur and all &quot;frees&quot=
;.</div><div><br></div><div>Thanks for your help,</div><div><br></div><div>=
Carter.=C2=A0</div></div>

--000000000000d6efa0057c4c79e0--
