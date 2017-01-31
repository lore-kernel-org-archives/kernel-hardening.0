Date: Tue, 31 Jan 2017 07:19:35 +0530
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Message-ID: <20170131071935.3e34cdd6@kaiwan-T460>
In-Reply-To: <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
References: <20170118095155.5e3bf976@kaiwan-T460>
	<90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Apologies for the delayed response!

>On Wed, 18 Jan 2017 11:44:47 -0800
>Laura Abbott <labbott@redhat.com> wrote:
> This is roughly the work I did before
> (http://www.openwall.com/lists/kernel-hardening/2015/12/22/1)

=E2=80=8BYes Laura, indeed it _is_ your code that I merged into linux-next,=
 just
attempting to move forward. Thanks :)
=E2=80=8B
> From that discussion, the conclusion is that we need to
> use the existing slab_debug infrastructure to do sanitization.
> The part in mm/page_alloc.c has been turned into a separate
> Kconfig.

Ok, so, I'll attempt working on going down this path, also taking into
account what you mentioned Kees.. will take it a step at a time though!=E2=
=80=8B
=20
> As Kees mentioned, a good task would be to create a new Kconfig
> (CONFIG_MEMORY_SANITIZE for example) that will turn on both
> CONFIG_DEBUG_PAGEALLOC (the equivalent of CONFIG_PAX_MEMORY_SANITIZE)
> and also turn on slab poisoning.
>=20
