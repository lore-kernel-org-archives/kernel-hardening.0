MIME-Version: 1.0
From: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Date: Sat, 16 Jun 2018 13:49:36 +0200
Message-ID: <CAAGnT3bjYPu9bordn_Dh8z+MW6p5DDLoSsZC9xg8QxQriVus9A@mail.gmail.com>
Subject: Design Decision for KVM based anti rootkit
Content-Type: text/plain; charset="UTF-8"
To: kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, riel@redhat.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>, virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org
List-ID: <kernel-hardening.lists.openwall.com>

Following up on these threads:
- https://marc.info/?l=kvm&m=151929803301378&w=2
- http://www.openwall.com/lists/kernel-hardening/2018/02/22/18

I lost the original emails so I couldn't reply to them, and also sorry
for being late, it was the end of semester exams.

I was adviced on #qemu and #kernelnewbies IRCs to ask here as it will
help having better insights.

To wrap things up, the basic design will be a method for communication
between host and guest is guest can request certain pages to be read
only, and then host will force them to be read-only by guest until
next guest reboot, then it will impossible for guest OS to have them
as RW again. The choice of which pages to be set as read only is the
guest's. So this way mixed pages can still be mixed with R/W content
even if holds kernel code.

I was planning to use KVM as my hypervisor, until I found out that KVM
can't do that on its own so one will need a custom virtio driver to do
this kind of guest-host communication/coordination, I am still
sticking to KVM, and have no plans to do this for Xen at least for
now, this means that in order to get it to work there must be a QEMU
support our specific driver we are planning to write in order for
things to work properly.

The question is is this the right approach? or is there a simpler way
to achieve this goal?
