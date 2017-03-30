Date: Thu, 30 Mar 2017 20:45:28 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170330194528.GJ7909@n2100.armlinux.org.uk>
References: <1490884982-5066-1-git-send-email-hoeun.ryu@gmail.com>
 <CAGXu5jLFDGO5OfOGa7B9H6pw8ivnL9MUsPZ=fQns-fbA6R-Ljw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLFDGO5OfOGa7B9H6pw8ivnL9MUsPZ=fQns-fbA6R-Ljw@mail.gmail.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [RFCv2] arm64: support HAVE_ARCH_RARE_WRITE and
 HAVE_ARCH_RARE_WRITE_MEMCPY
To: Kees Cook <keescook@chromium.org>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Laura Abbott <labbott@redhat.com>, Hugh Dickins <hughd@google.com>, Steve Capper <steve.capper@arm.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, James Morse <james.morse@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 30, 2017 at 12:38:15PM -0700, Kees Cook wrote:
> Great work! I think this will need some further changes, though, since
> it doesn't look to me like this would pass LKDTM's tests if it was
> built as a module. (This is missing from my ARM attempt too... I
> haven't figured out how to set the domain on the kernel modules...)

You're not going to be able to do it very easily.  The only way I can
think of achieving it would be to split the module area into one
chunk for text, one chunk for write-rare and one chunk for data.

I still think that using domains is a mistake for this - it's a good
solution for things that are contiguous and big (like userspace), but
not for small amounts of data (like module sections.)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
