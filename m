MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5d2fd950-98ec-440d-bed2-3f3f60c4c4f6@suse.de>
References: <2feb9661-9236-cdaf-a371-2fea80372aff@huawei.com>
 <CAGXu5jJwCx=LhvJGgNxD9Wu1NCTBb=yn0MQW05GSdocvqZf2Gg@mail.gmail.com>
 <0eb1d2c0-79ae-b2c9-4802-9104ec3db8ee@huawei.com> <5d2fd950-98ec-440d-bed2-3f3f60c4c4f6@suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 9 Aug 2017 17:06:03 -0700
Message-ID: <CAGXu5jJXLD4n2pGYfc0mkyrCLcBXZGAk8sMX6QsWOUH_jV0jTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening][RFD] Is there any plan to port the RAP feature
 from PAX/Grsecurity to main line ?
To: Joao Moreira <jmoreira@suse.de>
Cc: Li Kun <hw.likun@huawei.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 4, 2017 at 5:30 PM, Joao Moreira <jmoreira@suse.de> wrote:
> hi, I'm Joao, I talk for kCFI :)

Hi! Thanks for the reply!

>
> On 08/04/2017 07:31 AM, Li Kun wrote:
>>
>>
>>
>> =E5=9C=A8 2017/8/4 13:13, Kees Cook =E5=86=99=E9=81=93:
>>>
>>> On Thu, Aug 3, 2017 at 9:23 PM, Li Kun <hw.likun@huawei.com> wrote:
>>>>
>>>> Is there any plan to port the RAP feature from PAX/Grsecurity to main
>>>> line ?
>>>> I think that will be a realy effective approach to protect against
>>>> ROP/JOP.
>>>
>>> Yeah, RAP is pretty great! I'm not aware of anyone working on
>>> upstreaming the plugin (and its many function declaration fixes and
>>> other adjustments) currently, though.
>>
>> I will try to upstream it.
>> If i have any progress or trouble, i will show it here:)
>>>
>>>
>>> I've also been interested to see if kCFI[1] will be published soon,
>>> which would be another option (it needs fewer kernel changes, but has
>>> limitations like needing to build the kernel twice). While the code
>>> isn't released yet, they did provide a comparison[2] to RAP which is
>>> an interesting read.
>
>
> So, we wanted to have it released some time ago, but life happened and
> unfortunately, I had to share my time between this and other projects.

Is there anything specifically stopping release? Even getting
something that is just "works only kernel version X.Y" would be
excellent to have for people to examine.

> As you are speaking of "upstreamability", I see kCFI as an interesting
> start-point, but it is blurry to believe that it would be mergeable into =
the
> kernel. kCFI was/is a research project, willing to enable CFI
> experimentation in the kernel space. It never was understood as a product=
.
> Because of that, we took many decisions in the past that would benefit th=
is
> aspect of the work, instead of making it super maintainable or attachable=
.
> Some of these decisions were: 1st, kCFI is implemented on top of LLVM; 2n=
d,
> some of the most interesting features of kCFI require two compilation rou=
nds
> (and we didn't even care about it, because we were just trying to prove a
> point in making achievable kernel CFI more fine-grained); 3rd, we never
> ported it to newer kernel versions, instead we preferred to evaluate
> different approaches and solutions in that very same code-base (Linux ker=
nel
> 3.19); 4th, kCFI requires many external tools (which perform binary
> analyses, CFG fixes, etc).

That's fine -- I never expect large changes to the kernel to land in
one giant splash. Getting things into upstream in pieces tends to be
much saner. Having something to work from means people can help chip
away at the final goal.

> Just to illustrate why we took these paths think about, for example, not
> tagging all functions uniquely based on their prototype. I mean, if you h=
ave
> a function FOO and a function BAR, both with the same prototype, but such
> prototype never appears in a pointer declaration throughout source code, =
why
> do you need them having the same tags? This would allow FOO returning to =
a
> BAR's call-site, and BAR returning to a FOO's call-site. Yet, to know tha=
t
> such function pointer does not exist, we had to run a full compilation ro=
und
> before instrumenting, performing a source-code analysis.

Yup, exactly. I like this feature. What's the right term for this?
"Cluster splitting"?

> Given all the above I would say that someone interested in making CFI
> upstream, should not get demotivated by kCFI.
>
>> That looks awsome. Does it have any schedule to release the code?
>
>
> No, we don't have a release schedule. Our current plans are to finish som=
e
> final tests that we are doing, run some more benchmarks/use-cases so we c=
an
> extend a bit our false-positive coverage, and then have it out as soon as
> possible... but well, tbh, it may take some time.
>
> If someone wants to make CFI =E2=80=9Cupstreamable=E2=80=9D, I'm in for h=
elping in any way I
> can. I would suggest that anyone willing to achieve it should first try t=
o
> implement a coarse-grained scheme, have it booting and running, and only
> after that, think about the best way of organizing the tags so you
> minimize/cease the false-positives.

I'd love to not have to have people start from scratch (hint hint). :)

> If there is anything I can do, I=E2=80=99m lvwr in ##kernel-hardened or, =
just reach
> me through mail.

(For anyone following the thread, Joao pointed out to me on IRC that
the above was a typo. This should be ##linux-hardened on freenode.)

Thanks!

-Kees

--=20
Kees Cook
Pixel Security
