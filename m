Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 11 Nov 2015 04:41:28 +0100
MIME-Version: 1.0
Message-ID: <5642B8E8.684.312DEE18@pageexec.freemail.hu>
In-reply-to: <5640E0DD.6040107@labbott.name>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>, <563F4A78.21151.23C6852D@pageexec.freemail.hu>, <5640E0DD.6040107@labbott.name>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection features
To: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <laura@labbott.name>
Cc: Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 9 Nov 2015 at 10:07, Laura Abbott wrote:

> I took a look at something closely related sometime ago[1] for
> ARM DT based targets. The stack canary was always the same because
> it was early enough no entropy was being added and there's no standard
> RNG. This series proposed allowing entropy to be read out of the DT.
> This still relied on reliable entropy being added to the DT somehow.
> Ultimately, I never followed up and this still seems to be an issue.
> 
> The out of tree solution which was never submitted was to make a call
> to the hwrng very early to seed the pool. This was very SoC specific
> though. At the time I wrote the patches, I didn't look to see what
> Pax/GrSec might have had to address the issue.

to extract entropy via the plugin by the time start_kernel is called
you'd have to use the plugin for code that runs beforehand, i.e., the
firmware, boot loader, etc and also find a way to pass this entropy
to the kernel somehow. another feature of the plugin is to initialize
global variables with compile-time generated random numbers, but if
the kernel images are available to an attacker then it's of no use
of course. last but not least PaX also feeds hashes of every page into
the random pool as it gets taken over by the kernel allocator, this
could be run earlier to extract whatever entropy is left in RAM.

cheers,
 PaX Team
