MIME-Version: 1.0
In-Reply-To: <7337582f-0007-d006-0809-cf41fd93b31e@nutanix.com>
References: <CAAGnT3bjYPu9bordn_Dh8z+MW6p5DDLoSsZC9xg8QxQriVus9A@mail.gmail.com>
 <7337582f-0007-d006-0809-cf41fd93b31e@nutanix.com>
From: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Date: Tue, 19 Jun 2018 20:12:22 +0200
Message-ID: <CAAGnT3ZaT-BOodo6gM8C8QGDOTmYMjTaYX3G-RLscr35Qws0Wg@mail.gmail.com>
Subject: Re: Design Decision for KVM based anti rootkit
Content-Type: text/plain; charset="UTF-8"
To: David Vrabel <david.vrabel@nutanix.com>
Cc: kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, riel@redhat.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>, virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org
List-ID: <kernel-hardening.lists.openwall.com>

On 19 June 2018 at 19:37, David Vrabel <david.vrabel@nutanix.com> wrote:
> It's not clear how this increases security. What threats is this
> protecting again?
It won't completely protect prevent rootkits, because still rootkits
can edit dynamic kernel data structures, but it will limit what
rootkits damage to only dynamic data.
This way system calls can't be changed, or Interrupt tables.
> As an attacker, modifying the sensitive pages (kernel text?) will
> require either: a) altering the existing mappings for these (to make
> them read-write or user-writable for example); or b) creating aliased
> mappings with suitable permissions.
>
> If the attacker can modify page tables in this way then it can also
> bypass the suggested hypervisor's read-only protection by changing the
> mappings to point to a unprotected page.

I think I was missing this part out, but I meant to say completely
prevent any modification to pages including the guest physical address
to guest virtual address mapping for those protected pages, Another
tricky (something random just popped up in my mind right now, better
to say it than to forget it) solution is making new memory mappings
inherit the same protection as old one, I assume that Hyper visor can
do either things. Also that was the kind of performance hit I was
talking about. I am not sure if that might break things or I can say
it will for sure heavily limit some functionalities. like maybe
hibernating guest. But that will be the kind of trades off I am
expecting at least at the begining.
