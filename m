Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120522210704.GK11775@ZenIV.linux.org.uk>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
 <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
 <5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl>
 <CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com>
 <20120522173942.GJ11775@ZenIV.linux.org.uk> <CABqD9hbwnp-Kob0-Uc9L=qgJfS88po=RHNPkhQFcSf4RTrFCmQ@mail.gmail.com>
 <4FBBF84A.4070308@zytor.com> <CABqD9haSh=Tof9n2m8PHBaoqac1kcUZq-f5BcjDBv++5APGTCg@mail.gmail.com>
 <20120522210704.GK11775@ZenIV.linux.org.uk>
From: Roland McGrath <mcgrathr@google.com>
Date: Tue, 22 May 2012 14:17:03 -0700
Message-ID: <CAB=4xhrEhX9BX2bsn1P=dFhmXTafVuEXDKJb87a6ftDkJqJs7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>, Indan Zupancic <indan@nul.nu>, Eric Paris <netdev@parisplace.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 22, 2012 at 2:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> FWIW, I'd prefer to have all that done inside __audit_syscall_entry(),
> with
> =A0 =A0 =A0 =A0context->arch =A0 =A0 =A0 =3D syscall_get_arch(current, re=
gs);
> =A0 =A0 =A0 =A0context->major =A0 =A0 =A0=3D syscall_get_nr(current, regs=
);
> =A0 =A0 =A0 =A0syscall_get_arguments(current, regs, 0, 4, context->argv);
> done instead of initializations from arguments we are doing there now.
> I seriously doubt that it would lead to worse code than what we currently
> have. =A0If nothing else, we won't be passing that pile of arguments arou=
nd.

I always felt the same way about the audit code.  (As a bonus, if the audit
folks ever decide they want all six syscall arguments instead of just four,
they wouldn't have to touch every arch.)  But it will certainly produce
drastically worse code for ia64.  (Not that anybody cares about ia64.)


Thanks,
Roland
