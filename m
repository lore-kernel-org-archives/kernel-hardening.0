Reply-To: kernel-hardening@lists.openwall.com
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <563F4A78.21151.23C6852D@pageexec.freemail.hu>
From: Laura Abbott <laura@labbott.name>
Message-ID: <5640E0DD.6040107@labbott.name>
Date: Mon, 9 Nov 2015 10:07:25 -0800
MIME-Version: 1.0
In-Reply-To: <563F4A78.21151.23C6852D@pageexec.freemail.hu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>
Cc: Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/8/15 5:13 AM, PaX Team wrote:
> On 6 Nov 2015 at 15:30, Kees Cook wrote:
>>>   * latent_entropy: This plugin generates some entropy from program state
>>>      throughout the uptime of the kernel. It has small performance loss.
>>>      The plugin uses an attribute which can be
>>>      on a function (to extract entropy beyond init functions) or on a
>>>      variable (to initialize it with a random number generated at compile time)
>>
>> How large is the entropy extracted during early init? I bet a lot of
>> architectures would rejoice to have this available. (CCing Ted for
>> thoughts.)
>
> that's a good question nobody can answer unfortunately. thing is, this
> kind of instrumentation essentially builds a PRNG whose internal structure
> reflects the control flow of instrumented kernel functions, i.e., it's not
> something anyone can describe and analyze because of its size and dynamic
> nature (think loops with variable number of rounds, interrupts, etc).
>
> what one can do is measure the number of states the PRNG can end up in say
> right after boot and see how wide and uniform the distribution of states
> is. at the time i developed this plugin i ran a few tests on an allnoconfig
> amd64 kernel under qemu/kvm and even that environment produced a few bits
> of entropy (i.e., more than one state). however this kind of testing can
> scale only so far, e.g., to establish that say 30 bits of entropy can be
> generated this way by the time init is called, one would have to boot the
> kernel billions of times already...
>

I took a look at something closely related sometime ago[1] for
ARM DT based targets. The stack canary was always the same because
it was early enough no entropy was being added and there's no standard
RNG. This series proposed allowing entropy to be read out of the DT.
This still relied on reliable entropy being added to the DT somehow.
Ultimately, I never followed up and this still seems to be an issue.

The out of tree solution which was never submitted was to make a call
to the hwrng very early to seed the pool. This was very SoC specific
though. At the time I wrote the patches, I didn't look to see what
Pax/GrSec might have had to address the issue.

Thanks,
Laura

[1]http://thread.gmane.org/gmane.linux.kernel/1646202/focus=61628
