Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Sun, 08 Nov 2015 15:09:26 +0100
MIME-Version: 1.0
Message-ID: <563F5796.7439.23F9C28C@pageexec.freemail.hu>
In-reply-to: <20151108092717.GH18245@li141-249.members.linode.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>, <20151107054217.GA32075@x>, <20151108092717.GH18245@li141-249.members.linode.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection features
To: kernel-hardening@lists.openwall.com, Alyssa Milburn <amilburn@zall.org>
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, Emese Revfy <re.emese@gmail.com>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 8 Nov 2015 at 9:27, Alyssa Milburn wrote:

> On Fri, Nov 06, 2015 at 09:42:17PM -0800, Josh Triplett wrote:
> > (For that matter, as the LLVM Linux project progresses, it might
> > actually prove easier to provide a clang-based plugin.)
> 
> If anyone is interested in LLVM-based plugins (I've been assuming nobody
> is, especially since LLVMLinux seems to have been pretty quiet recently),

actually i originally wanted to use clang/llvm as the basis for my
compiler based work, way back in 2009. it's not a coincidence that
a bit later i could contribute all that code to make clang able to
compile linux. while for practical reasons my interests had shifted
to gcc afterwards, i still have an interest in revitalizing my work
on the clang/llvm side so if you can/want to, feel free to share your
work and i'll help bring it into shape. i'm also only a humble student
of llvm internals so any comparative work such as ports of existing
gcc plugins would be of tremendous help in getting familiar with how
the clang/llvm side of the world works.

cheers,
 PaX Team
