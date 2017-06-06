MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170604114320.GA1437@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net> <CAGXu5j+YGaczVB7xE9t_M83dcGJjmQsr=weQwEG3NHsmHrK7SA@mail.gmail.com>
 <20170604114320.GA1437@grsecurity.net>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 5 Jun 2017 17:29:20 -0700
Message-ID: <CAGXu5jL-CQ3y_uTqQiuRny2+zHpiNO3Z--=JPkPBcYBijMf4PQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 4, 2017 at 4:43 AM, Brad Spengler <spender@grsecurity.net> wrote:
> On Sun, Jun 04, 2017 at 12:16:43AM -0700, Kees Cook wrote:
>> (Hilariously, this email was detected as spam and never hit my inbox.
>> Dug it out now...)
>
> I'm glad you're taking this so seriously that you find it all hilarious.
> It really sets a great example for the rest of the KSPP and demonstrates
> the great deal of respect for the work your entire career has been based off.

I am taking it seriously, and I've been quite clear about the respect
I have for PaX Team and your work. I found it ironically funny that
automated spam systems hid a very important email from me for almost a
day. There's no need to read malice into everything.

Of similar dark humor is the laughable proposition you can claim
credit for my entire career. I genuinely wonder if you're able to
write an email without personal attacks.

>> Perhaps a more prominent FAQ entry is needed on the KSPP Wiki?
>
> That might help, and also self-policing so that we don't need to be the
> ones monitoring every commit and having to bring these issues up again
> and again.  For the record, to my knowledge I don't know of anyone
> who has contributed code to the KSPP who has emailed us to ask how to
> do that attribution.  Copyright attribution is a legal mandate, questions
> about how to do that are better suited for a lawyer.  Attribution of
> ideas/"inspired" code etc is a moral issue (and this is where plagiarism
> comes into play).

Well, as I've shown repeatedly, I don't think I've screwed this up. As
for the self-policing, that's something I've encouraged people to do
(see the link I sent). It does appear to be insufficient, and, while
it seems highly redundant to me since both projects are Open Source,
I've still added a section to the Wiki about it, so it'll be easier to
point out to people:

http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Get_Involved

> As far as what would make us happy, something like this would be perfect,
> especially if the changelog makes certain claims about larger features.
> Obviously it's overkill for smaller changes, but since you asked:
>
> Blah is verbatim/modified from Brad Spengler/PaX Team's code in the last
> public patch of grsecurity/PaX based on my understanding of the code.  Changes
> or omissions from the original code are mine and don't reflect the original
> grsecurity/PaX code.

I've added this to the Wiki as well (linked above), please double
check that you're happy with the wording. I will update my own pending
patches to update their commit logs to include this.

> But if you also want to know how to attribute, there's the Linux kernel's
> own DCO, which you and the rest of the KSPP are violating left and right.
> Here are some select quotes:
> "  If you are a subsystem or branch maintainer, sometimes you need to slightly
>    modify patches you receive in order to merge them, because the code is not
>    exactly the same in your tree and the submitters'. If you stick strictly to
>    rule (c), you should ask the submitter to rediff, but this is a totally
>    counter-productive waste of time and energy. Rule (b) allows you to adjust
>    the code, but then it is very impolite to change one submitter's code and
>    make him endorse your bugs. To solve this problem, it is recommended that
>    you add a line between the last Signed-off-by header and yours, indicating
>    the nature of your changes. While there is nothing mandatory about this, it
>    seems like prepending the description with your mail and/or name, all
>    enclosed in square brackets, is noticeable enough to make it obvious that
>    you are responsible for last-minute changes.
> "
>
> "  Note that under no circumstances can you change the author's identity
>    (the From header), as it is the one which appears in the changelog.
> "
>
> "  The canonical patch message body contains the following:
>
>    - A ``from`` line specifying the patch author (only needed if the person
>      sending the patch is not the author).
> "
>
> "  From: Original Author <author@example.com>
>
>    The ``from`` line specifies who will be credited as the author of the
>    patch in the permanent changelog.  If the ``from`` line is missing,
>    then the ``From:`` line from the email header will be used to determine
>    the patch author in the changelog.
> "
>
> As far as I know, none of these rules have ever been followed for our code.
> Further, the author field has been used in the past (eg. by James Bottomley)
> as "proof" of our lack of authorship of code in the Linux kernel:
> https://lwn.net/Articles/663629/
> "
>   > as for getting code upstream, how about you check the kernel git logs
>   > (minus the stuff that was not properly credited)?
>   jejb@jarvis> git log|grep -i 'Author: pax.*team'|wc -l
>   1
>   Stellar, I must say.
> "

Okay, so I would take this to mean you would like folks doing
grsecurity upstreaming to add the body "From:" line (i.e. git
"Author:") to patches? I see a variety of problems with this, but
mainly that the Author and first Signed-off-by line are supposed to
match, and "forging" someone's S-o-b sounds like a _terrible_ idea to
me. That would indicate that the "author" had actually sent such a
patch upstream, followed DCO, etc, and that would not be true. No one
should be forging Author/S-o-b. The DCO exists specifically to allow a
Linux kernel developer to assert that they have the right to send the
code in question (i.e. copy it from a compatibly licensed project).

If you want to send code, and if I modified it before commit, then
yeah, I'd already be following all these guidelines. Just go look at
my commit history in the kernel. I do the square-brackets thing, I
obviously retain S-o-b chains and original Author fields, etc. That's
just normal kernel development practices.

So, what exactly are you asking to be changed with regard to following the DCO?

I'd like to make sure you're happy about the attribution and
copyright, but you've repeatedly sent mixed signals for years now. For
example: I list specifically all the changes made to some
implementation vs the grsecurity one, and PaX Team tells me it's too
much detail and I shouldn't do it. I give credit _without_ mentioning
the implementation changes and you tell me it is so "broken" that you
don't want grsecurity associated with the results.

As I currently understand it, the paragraph from your last email that
I've added to the KSPP Wiki is the middle ground you are okay with?

>> > https://lwn.net/SubscriberLink/724319/830a4de15663b8dd/
>> > over a dozen mentions of various forms of "Cook's implementation"
>>
>> Let's see, the paragraph in the article that talks about the proposal
>> credits PaX/grsecurity. Clicking through to my proposed series shows
>> the first paragraph crediting PaX/grsecurity. You seem to be arguing
>> semantics, rather than credit?
>
> Did you not see:
> https://lwn.net/Articles/724396/
> https://lwn.net/Articles/724401/
>
>> this LWN article being published. And as I already said, it's not
>> misattributed. You're just willfully misreading it.
>
> Clearly based on other comments other people found it misleading as well --
> perhaps you are just in denial about how damaging this kind of stuff is?
> As was mentioned there, you properly credited it, but others misattributed
> it to you.  It'd be as if I backported an ext4 encryption patch, and then
> LWN writes an article about "my" implementation and "my" code and "my" work.
> You don't find that misleading at all?  Assuming you had seen the article,
> would you have corrected it yourself, or would you act in the same way as
> you've demonstrated with every other misattribution and misleading marketing
> that benefits you and the KSPP and ignore it, expecting it to magically
> resolve itself?  Because going forward those kinds of lies and damaging
> claims are going to be resolved with lawsuits.  This has been going on
> for almost two years now and forced us to remove the public patches
> entirely because of all this nonsense to try to put and end to it, but
> clearly no matter of complaining is stopping it, so we have no other
> option left.

I don't do marketing. I didn't write this article. I don't understand
why you conflate all these things together. I believe I'm clear in my
commit logs. Would this article have been different if I'd used your
credit paragraph wording? I don't have the time to run around
correcting every misunderstood thing written about this kind of work.
I know you view this as a moral failing on my part, but usually by the
time I even see these kinds of articles, there is already a huge
thread of people discussing the inaccuracies, etc; my voice would be
redundant. I'm not a liar, and I'm not misleading anyone. I've been
clear and concise, and I remain dedicated to giving credit to
grsecurity as much as I can.

One area that I think may confuse people is the level to which some
code needs to be refactored for upstreaming. A lot of it tends to be
moving things around and renaming stuff to be acceptable upstream
(e.g. moving heap object checking routines out of fs/exec.c into
mm/usercopy.c), so comparisons can be complicated, but I've always
tried to minimize this so it is as easy as possible to compare it
against grsecurity (and to make your own forward porting easier,
though you refuse to discuss even that with me). Feature extraction
from a monolithic patch with no public git history can be pretty
awkward, and while I have become familiar with it, not everyone
quickly understands the resulting patches, even though I try to
specify what has changed between my patches and grsecurity.

>> Make up your mind about how you want grsecurity attributed and maybe
>> people will actually do it "right". But you don't seem to actually
>> want that, since you appear to just want to discourage anything that
>> even looks like grsecurity from going upstream. If you think you're
>> amply credited, you get mad that it's TOO MUCH credit because the
>> resulting code is different from grsecurity and it's giving you a bad
>> name somehow.
>
> Yes, as I mentioned above, it's due to two separate issues.  One is using
> the grsecurity reputation as a crutch for your own ability and marketing
> based off it, and the other is ensuring attribution of the original
> ideas/code.  It seems pretty simple to me.

I'm not using grsecurity's reputation, I'm using grsecurity's code.
You may have a low opinion of my abilities, but this project with many
contributors have actually had some success in bringing more defensive
technologies into the Linux kernel. Some of it is code from
grsecurity, some of it is ideas from grsecurity, some of it is new
code and new ideas.

>> grsecurity. Just ask arm64 system builders how useful grsecurity was
>> for them.
>
> Yeah just ask those same system builders how much they were willing
> to pay for any arm64 work, Google included.  ARM64 is your hobby horse,
> you like bringing it out as an example every chance you can get, because
> it's the only example you can bring up of any original work being done.
> I learned my lesson with my ARM work not to do any more free work for
> that industry.

I use that example because it's definitive. There are other examples,
but I tend to avoid mentioning them to you since I assume you will
freak out when I talk about KASLR. :) I know you think it's garbage,
but I don't, and others don't, and so people spend time on it.

>> You've been upset in the past about seemingly NIHed code like
>> VMAP_STACK or ARM's use of Domains, but those were implemented without
>> those authors reading grsecurity, IIUC. In fact, you've regularly
>> harassed them because you think their implementations are bad. That
>> can hardly be considered uncredited derivative work.
>
> I don't just think they're bad, they are bad -- I explained what's wrong
> with them.  How many dozen CVEs for VMAP_STACK are needed to prove it in
> your mind?  Three? Four?  Also I tend not to believe people who post on
> LKML about deep details of some code they looked at, who then try to claim
> later that they never looked at it deeply:
> https://lwn.net/Articles/692208/

This has been discussed ad nauseam before. The upstream Linux kernel
has totally different engineering and development practices than
grsecurity. Without VMAP_STACK, the vulnerabilities associated with
non-vmap kernel stacks existed in upstream and how many very
general-purpose CVEs affected the kernel (and would have continued to
affect the kernel)? Too many. But Andy was able to do the
implementation (I can't speak to his lack of crediting the idea to
grsecurity, you'll have to ask him). With this implementation in
place, now those kernel stack exploit methods are dead. If the cost
was an ever diminishing number of very specific CVEs, then that's
where we are. Upstreaming is a balancing act. You can criticize it all
you want, but it's the reality of how Linux development works.

> As for the ARM PAN code, I'm glad you brought it up because it's time to
> put the facts of this one to rest.
>
> I do hope one day for the mystery to be solved of how a public mail from Google:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-August/365056.html
> magically got responded to within 3 days with a patch ready:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-August/365662.html
> mentioning prior private discussions (with Google?) and Catalin Marinas,
> whom I had told explicitly of my ARM work (the LPAE TTBR0 trick, a bug
> in marking sections read-only under LPAE, and the domain
> implementation) in 3 emails on Jan 2nd 2013, Jan 3rd 2013, and Jan 21
> 2013, and then also followed up on Feb 19 2013 with a link to the ARM
> KERNEXEC/UDEREF blog post.  Lo and behold, the patchset based on
> private discussions with the person I directly shared the
> implementation ideas with (and long after I had already presented on
> them, published the code, and the detailed blog) appears without any
> credit.  Perhaps caught the cryptomnesia bug that's been going around.

If what you're saying is true, then, yeah, it's disappointing that the
ideas weren't credited. But from that same thread, here I am, trying
to make sure grsecurity got noticed:
http://lists.infradead.org/pipermail/linux-arm-kernel/2015-August/366046.html

The resulting thread certainly gives some insight into the long
(usually acrimonious) relationship between grsecurity and upstream,
but I don't feel I was contributing to that; I think I've always tried
to help people find a middle ground. And for my troubles I get nothing
but personal attacks from you.

>> You appear to be trying to bully people into not contributing to the
>> upstream effort to make Linux more secure. Please stop.
>
> You appear to be justifying plagiarism and copyright/trademark infringements
> in the name of making Linux "more" secure.  Please stop.

After all the evidence to the contrary, why do you continue to feel this way?

I really do genuinely want to have you be happy with how pieces of
grsecurity get upstreamed, but you've persistently berated and mocked
the resulting code compromises, which has made that goal basically
impossible. :(

> I'm still going on "rants" because the KSPP as a whole continues to
> surround itself with misleading marketing no member ever takes initiative
> to correct, and continues to remove copyright notices and/or replace them
> with someone else's.  A rant will be the least of your worries if this
> continues, and as creator of the KSPP and effective figurehead/spokesperson
> you'd be wise to start taking it seriously.

I haven't surrounded KSPP with any marketing. That a patch set gets
"PR" attention or not has nothing to do with me or KSPP. Yes, I'm
going to talk about KSPP in public, but I don't think I've ever
misrepresented anything about the project or the work. I just want
people to be aware of it, understand its goals, purpose, and
limitations, and to be inspired to help out.

And like I've said, usually by the time some article or other thing
has been noticed by me, all the corrections are well under way. I'm
sure it'll sound like a hollow excuse from me, but I don't have
infinite time. If that'll be my failing here, so be it. Luckily there
are plenty of other people that notice these things and correct them.

But at least we have one thing we can agree on: the copyright removal
thing was especially bad. Intel screwed that up before, and it's
happened again here with what Matt sent. Those have been objective
(and rare) mistakes. I think neither were motivated by malice, more
like self-imposed legal formalities combined with there being such
little experience copying between GPL projects where one project is a
single patch file with a copyright notice in a subdirectory Makefile.
(Which is an explanation, not an excuse.)

For what it's worth, Intel's mistake never made it to Linus's tree,
and you noticed Matt's before I'd read through the patches in any
detail (which were also no where near being committed upstream). So,
while it really seems to me like this sort of thing should have been
obvious, I called it out specifically in the Wiki (linked above).

-Kees

-- 
Kees Cook
Pixel Security
