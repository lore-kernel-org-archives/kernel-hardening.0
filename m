Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
Date: Wed, 6 Apr 2016 11:21:21 -0700
Message-ID: <CAGXu5jLHTzLEsAcF0eHN7xj_Y-jRLtxyjoQVj__AmaXVVSdSzA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Emrah Demir <ed@abdsec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 11:05 AM,  <ed@abdsec.com> wrote:
> First, I wrote your attached patch, but then I thought zeroing other
> /proc/iomem values would be better. So I changed it.
>
> Most distros don't use KASLR, but they use kptr_restrict. Without KASLR,

Well, hopefully that'll change over time. :)

> kptr_restirct most likely useless. As you said these things should be don=
e
> long ago

This results in a warning, but the kernel's printf formatting supports it:

kernel/resource.c: In function =E2=80=98r_show=E2=80=99:
kernel/resource.c:118:4: warning: '0' flag used with =E2=80=98%p=E2=80=99 g=
nu_printf
format [-Wformat=3D]

I'm not sure how to best suppress that...

diff --git a/kernel/resource.c b/kernel/resource.c
index 2e78ead30934..d5881d143fb6 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -111,10 +111,10 @@ static int r_show(struct seq_file *m, void *v)
        for (depth =3D 0, p =3D r; depth < MAX_IORES_LEVEL; depth++, p =3D =
p->parent)
                if (p->parent =3D=3D root)
                        break;
-       seq_printf(m, "%*s%0*llx-%0*llx : %s\n",
+       seq_printf(m, "%*s%0*pK-%0*pK : %s\n",
                        depth * 2, "",
-                       width, (unsigned long long) r->start,
-                       width, (unsigned long long) r->end,
+                       width, (void *) r->start,
+                       width, (void *) r->end,
                        r->name ? r->name : "<BAD>");
        return 0;
 }

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
