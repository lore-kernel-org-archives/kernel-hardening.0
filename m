Subject: Re: Design Decision for KVM based anti rootkit
References: <CAAGnT3bjYPu9bordn_Dh8z+MW6p5DDLoSsZC9xg8QxQriVus9A@mail.gmail.com>
From: David Vrabel <david.vrabel@nutanix.com>
Message-ID: <7337582f-0007-d006-0809-cf41fd93b31e@nutanix.com>
Date: Tue, 19 Jun 2018 18:37:53 +0100
MIME-Version: 1.0
In-Reply-To: <CAAGnT3bjYPu9bordn_Dh8z+MW6p5DDLoSsZC9xg8QxQriVus9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Ahmed Soliman <ahmedsoliman0x666@gmail.com>, kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, riel@redhat.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>, virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org
List-ID: <kernel-hardening.lists.openwall.com>

On 16/06/18 12:49, Ahmed Soliman wrote:
> 
> To wrap things up, the basic design will be a method for communication
> between host and guest is guest can request certain pages to be read
> only, and then host will force them to be read-only by guest until
> next guest reboot, then it will impossible for guest OS to have them
> as RW again. The choice of which pages to be set as read only is the
> guest's. So this way mixed pages can still be mixed with R/W content
> even if holds kernel code.

It's not clear how this increases security. What threats is this
protecting again?

As an attacker, modifying the sensitive pages (kernel text?) will
require either: a) altering the existing mappings for these (to make
them read-write or user-writable for example); or b) creating aliased
mappings with suitable permissions.

If the attacker can modify page tables in this way then it can also
bypass the suggested hypervisor's read-only protection by changing the
mappings to point to a unprotected page.

David
