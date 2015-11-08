Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 8 Nov 2015 09:27:17 +0000
From: Alyssa Milburn <amilburn@zall.org>
Message-ID: <20151108092717.GH18245@li141-249.members.linode.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <20151107002508.GA2605@cloud>
 <20151107024612.GC19551@kroah.com>
 <CAGXu5jK70Rn3QqzkwDRMDmt-sW0Xhw0X8afp3KLgw4SYPiZHrQ@mail.gmail.com>
 <20151107054217.GA32075@x>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151107054217.GA32075@x>
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 06, 2015 at 09:42:17PM -0800, Josh Triplett wrote:
> (For that matter, as the LLVM Linux project progresses, it might
> actually prove easier to provide a clang-based plugin.)

If anyone is interested in LLVM-based plugins (I've been assuming nobody
is, especially since LLVMLinux seems to have been pretty quiet recently),
I've been investigating security improvements via compiler plugins as part
of my MSc project, and I'd love to write LLVM/clang passes/analyses if
anyone has any particular wishes for them. (But trying to replicate this in
gcc plugins is not something I can justify at present, especially since
Emese already has many covered.)

I already partially reimplemented a couple of the plugins from the
grsecurity patchset, but right now they're a mess bound up in all of my
other code (and I have no nice infrastructure, just hacks resting on top of
the last version of LLVMLinux + patches + LTO + LTO-on-LLVM + ...). On the
kernel side I just wanted to see how *this* vulnerability could have been
mitigated with *that* technique for *this* performance penalty, so as long
as I can compile+boot a kernel for benchmarking, I've been happy.

- Alyssa
