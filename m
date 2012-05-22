Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <4FBC0078.7010002@zytor.com>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
	<CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
	<5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl>
	<CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com>
	<20120522173942.GJ11775@ZenIV.linux.org.uk>
	<CABqD9hbwnp-Kob0-Uc9L=qgJfS88po=RHNPkhQFcSf4RTrFCmQ@mail.gmail.com>
	<4FBBF84A.4070308@zytor.com>
	<CABqD9haSh=Tof9n2m8PHBaoqac1kcUZq-f5BcjDBv++5APGTCg@mail.gmail.com>
	<4FBC0078.7010002@zytor.com>
Date: Tue, 22 May 2012 16:14:10 -0500
Message-ID: <CABqD9haL4pZHJOODh88=HVAJo8DBDJtQAJtSf_L-+518kgEqwg@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Indan Zupancic <indan@nul.nu>, Roland McGrath <mcgrathr@google.com>, Eric Paris <netdev@parisplace.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 22, 2012 at 4:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/22/2012 01:48 PM, Will Drewry wrote:
>>
>> That was my first thought too, so I ran a few simple tests. =A0gcc isn't
>> smart enough to not add ~344 bytes of code to get the number and
>> arguments for the x86/kernel/ptrace.c case I included (in the
>> naive-est of integrations). =A0But I don't know that it justifies the
>> extra patchwork or enforcing shared code across arches.
>>
>
> I suspect the construction of those inlines can be improved.

Seems likely - or just my use of them :)
