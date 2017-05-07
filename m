MIME-Version: 1.0
In-Reply-To: <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <20170504154717.GA24353@infradead.org> <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Sun, 7 May 2017 22:20:31 +0200
Message-ID: <CAFLxGvwuMN52-Xf46j7XuG+cnJ9xnZjXWhihpgxr9_EUX0Z+Bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not map
 kernel in user mode
To: Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: Christoph Hellwig <hch@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, "anders.fogh@gdata-adan.de" <anders.fogh@gdata-adan.de>
List-ID: <kernel-hardening.lists.openwall.com>

Daniel,

On Fri, May 5, 2017 at 9:40 AM, Daniel Gruss
<daniel.gruss@iaik.tugraz.at> wrote:
> I'm sure the overhead on older systems is larger than on recent systems.

Just did a quick test on my main KVM host, a 8 core Intel(R) Xeon(R)
CPU E3-1240 V2.
KVM guests are 4.10 w/o CONFIG_KAISER and kvmconfig without CONFIG_PARAVIRT.
Building a defconfig kernel within that guests is about 10% slower
when CONFIG_KAISER
is enabled.

Is this expected?
If it helps I can redo the same test also on bare metal.

-- 
Thanks,
//richard
