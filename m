Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4FBC02B3.7080906@zytor.com>
Date: Tue, 22 May 2012 14:18:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com> <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com> <5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl> <CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com> <20120522173942.GJ11775@ZenIV.linux.org.uk> <CABqD9hbwnp-Kob0-Uc9L=qgJfS88po=RHNPkhQFcSf4RTrFCmQ@mail.gmail.com> <4FBBF84A.4070308@zytor.com> <CABqD9haSh=Tof9n2m8PHBaoqac1kcUZq-f5BcjDBv++5APGTCg@mail.gmail.com> <20120522210704.GK11775@ZenIV.linux.org.uk> <CAB=4xhrEhX9BX2bsn1P=dFhmXTafVuEXDKJb87a6ftDkJqJs7A@mail.gmail.com>
In-Reply-To: <CAB=4xhrEhX9BX2bsn1P=dFhmXTafVuEXDKJb87a6ftDkJqJs7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: Roland McGrath <mcgrathr@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Will Drewry <wad@chromium.org>, Indan Zupancic <indan@nul.nu>, Eric Paris <netdev@parisplace.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 05/22/2012 02:17 PM, Roland McGrath wrote:
> (As a bonus, if the audit folks ever decide they want all six syscall
> arguments instead of just four

Is there anything about audit which *isn't* a gigantic facepalm?

	-hpa
