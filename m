Date: Tue, 09 May 2017 16:19:41 -0400 (EDT)
Message-Id: <20170509.161941.675253656642957586.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHgaXd+xb5dN90sH___RtxgSC3usnH2jXkA5r3=fQJc3pOY5xw@mail.gmail.com>
References: <CAHgaXdJ1M4W3p9=B2hJmtxByPsA5-XHae8U6YtDH_2r_XMaR5A@mail.gmail.com>
	<58E639E0.1010700@iogearbox.net>
	<CAHgaXd+xb5dN90sH___RtxgSC3usnH2jXkA5r3=fQJc3pOY5xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: arch: arm: bpf: Converting cBPF to eBPF for arm 32 bit
To: illusionist.neo@gmail.com
Cc: daniel@iogearbox.net, keescook@chromium.org, mgherzan@gmail.com, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, ast@fb.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Wed, 10 May 2017 01:42:10 +0530

> Why is trying to execute TAX which is a cBPF instruction?

Because some of the tests are classic BPF programs which
get translated into eBPF ones and sent to the JIT for
compilation.
