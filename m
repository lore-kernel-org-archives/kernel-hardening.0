Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110802124530.GA2543@albatros>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
 <20110802124530.GA2543@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Aug 2011 21:43:23 -1000
Message-ID: <CA+55aFx_FMg2Y0jMrzYUpAqgxWFjxnFzzrqvysoqrYyz+Ue6BQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary=0016363ba58e05d7b904a995065c
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

--0016363ba58e05d7b904a995065c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 2, 2011 at 2:45 AM, Vasiliy Kulikov <segoon@openwall.com> wrote=
:
>
> From: Vasiliy Kulikov <segoon@openwall.com>
> Subject: [PATCH] shm: fix a race between shm_exit() and shm_init()

This patch is disgusting.

Doing things like this:

> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* For init_ipc_ns shm_ids().rw_mutex is statically initi=
alized
> + =A0 =A0 =A0 =A0* as kernel threads should be able to use it in do_exit(=
) before
> + =A0 =A0 =A0 =A0* shm_init(), which is called on do_initcall()
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (ns =3D=3D &init_ipc_ns)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __ipc_init_ids(&shm_ids(ns));
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ipc_init_ids(&shm_ids(ns));

should have told you that there is something totally wrong with your patch.

I'd prefer to really do the initialization in the allocator (at which
point it would be very natural to do the initialization statically for
a static allocation, and you wouldn't have the above kind of nasty
conditional stuff), but that whole namespace initialization and setup
just looks pretty nasty.

Looking at some of the other cases like net_ns_init(), maybe the
proper fix is to just make 'ipc_ns_init()' be a pure_initcall().

Does the attached patch work?

              Linus

--0016363ba58e05d7b904a995065c
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqvzpc2p0

IGlwYy9zaG0uYyB8ICAgIDkgKysrKysrKystCiAxIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pcGMvc2htLmMgYi9pcGMvc2htLmMK
aW5kZXggOWZiMDQ0ZjNiMzQ1Li4zNzkxZmQ4NjViYmQgMTAwNjQ0Ci0tLSBhL2lwYy9zaG0uYwor
KysgYi9pcGMvc2htLmMKQEAgLTEwNSw5ICsxMDUsMTYgQEAgdm9pZCBzaG1fZXhpdF9ucyhzdHJ1
Y3QgaXBjX25hbWVzcGFjZSAqbnMpCiB9CiAjZW5kaWYKIAotdm9pZCBfX2luaXQgc2htX2luaXQg
KHZvaWQpCitzdGF0aWMgaW50IF9faW5pdCBpcGNfbnNfaW5pdCh2b2lkKQogewogCXNobV9pbml0
X25zKCZpbml0X2lwY19ucyk7CisJcmV0dXJuIDA7Cit9CisKK3B1cmVfaW5pdGNhbGwoaXBjX25z
X2luaXQpOworCit2b2lkIF9faW5pdCBzaG1faW5pdCAodm9pZCkKK3sKIAlpcGNfaW5pdF9wcm9j
X2ludGVyZmFjZSgic3lzdmlwYy9zaG0iLAogI2lmIEJJVFNfUEVSX0xPTkcgPD0gMzIKIAkJCQki
ICAgICAgIGtleSAgICAgIHNobWlkIHBlcm1zICAgICAgIHNpemUgIGNwaWQgIGxwaWQgbmF0dGNo
ICAgdWlkICAgZ2lkICBjdWlkICBjZ2lkICAgICAgYXRpbWUgICAgICBkdGltZSAgICAgIGN0aW1l
ICAgICAgICByc3MgICAgICAgc3dhcFxuIiwK
--0016363ba58e05d7b904a995065c--
