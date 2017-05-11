From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 11 May 2017 03:24:35 +0200
MIME-Version: 1.0
Message-ID: <5913BD53.14417.3F7C9BC9@pageexec.freemail.hu>
In-reply-to: <CAGXu5j+nB-0B9UNWV_u+xdWtmLnUQewfGXi2Kd=KjSLrcQu=NQ@mail.gmail.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>, <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>, <CAGXu5j+nB-0B9UNWV_u+xdWtmLnUQewfGXi2Kd=KjSLrcQu=NQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: Quoted-printable
Content-description: Mail message body
Subject: Re: [kernel-hardening] It looks like there will be no more public versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>, Kees Cook <keescook@chromium.org>
Cc: Daniel Cegielka <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

i think i'm not the only one to notice that the past two weeks
have been an interesting experience to say the least. ever since
our announcement about the fate of our test patch series we've
been silent but not because we had nothing to say (as you've no
doubt guessed by now, this mail is it). rather, we've used the
opportunity the announcement created to see just what comes out
of the woodwork. you see, we've always wondered about this kernel
security game, who wants what, who's doing what, who's p(l)aying
whom, etc. in other words, we wondered if the participants of the
game would show their true colors in the situation. and show they
did, it was well worth the wait.

as far as i could piece together the narrative propagated by Kees
Cook of Google, Greg Kroah-Hartman of the Linux Foundation, LWN's
Jonathan Corbet, the Linux Foundation's CII, and other less known
players, the story is that said entities have found (some of them
after years of ignoring the problem) that their security needs
could be best solved by upstreaming our code but all their attempts
to work out a deal with us for said purpose have failed and thus we
are to blame for everything under the sun and then some. and if
that weren't enough, they then went on the offensive with lots of
self-congratulating bravado and outright attacks on us and our
projects.

one can't help but notice that behind all the garbage spewed at
us, someone was getting very worried about the fate of the KSPP
fork of our work. what i can tell them now is that they will have
a whole lot more to worry about once they finished reading our
response. before we'll get to particular claims, we'll first look
at some history to set the stage for some of our answers.

my side started in 2000 as a hobby project that i worked on
entirely in my free time. i used to jokingly refer to it as a
'weekend project' as that's literally when i had time for it
due to my day jobs. later years didn't change much except for
the periods when i was without a job (amounting to over a decade)
and thus had more free time on my hand. Brad started his project
a bit later than me and has always worked on it in his free time.

as a true community project (KSPP's is very far from it, see
below) we have received lots of generous help over the years in
the form of hardware and financial donations that however didn't
quite cover our costs so at some point we were forced to run the
project in a more formal manner to be able to accept corporate
sponsorship (this is what OSS was originally created for). at
some point we also decided to begin supporting selected kernel
versions for a longer period of time in addition to the latest
upstream kernel. this proved to be a nice bonus and even
incentive for corporate sponsors.

all was well until a few years ago when we learned of several
blatant copyright violations (not of just our code but by extension
that of the upstream kernel too) and also trademark violations.
pursuing these wasn't too successful and in order to prevent
further abuse we decided to stop the public distribution of
our stable patches and provide it as an entirely commercial
product from then on (all still under the GPL, despite much
speculation to the contrary).

this proved to be a better decision and all seemed well for a few
months until the Washington Post article on kernel security appeared.
this turned out to be a game changer event in that linux security
got a serious look at from high level corporate executives and
resulted in Google tasking Kees Cook to start to work on the KSPP
with the express purpose of upstreaming grsecurity - all without us.

at this point we'd like to make it clear that any statements from
Kees/Greg/etc to the contrary are simply *lies*, neither i nor Brad
have ever been contacted by any of the corporations paying for the
KSPP. since proving a negative is hard, instead hereby we give any
corporate attorney, executive (or any other officer who thinks
that they gave us an offer that we refused) permission to post any
private emails including financial details, contract terms, etc that
prove us wrong. as a sidenote, there's some irony in that Kees and
Greg managed to tell contradicting lies as according to one we refused
to get paid to upstream our code whereas the other said that the
Linux Foundation had funded 'members of the grsecurity team'. in
reality, neither happened as such offers that we could refuse or
accept have never been made. it's also telling that when upstreaming
our code came up in private conversations where Kees was present,
his best suggestion at the time (around 2015 summer) was to try
the freshly expanded CII instead of, say, his own employer Google
(last month after he got an early notification about our plans
regarding the test patches, he in fact admitted that Google was
never going to pay us for the upstreaming work).

the CII is also an interesting animal in that they can't seem to
figure out what exactly it is they want. during the summer of
2015 i was CC'd into an email thread on cii-discuss where some
of our users suggested that the CII take up funding our projects.
at the time the CII stated that they would not provide funds
that'd amount to effective employment and also that they'd be
only interested in upstreaming our work. when i asked if they
were then willing to fund thousands of hours of such work, i got
no response and left it at that. now imagine my surprise when i
saw their recently published annual report for 2016 which has
this following beauty in there:

   One challenge we=E2=80=99ve encountered this year is finding skilled 
   people to take on the work. While the desire to work on 
   open source exists, without compensation it=E2=80=99s simply not 
   feasible for many developers to do so. Emese Renfy, for 
   example, had to step back from Kernel Self Protection 
   Work because funding from CII took so long to approve. 
   We=E2=80=99ve worked to resolve this with our new online grant 
   system. Another solution is to find those who are already 
   working on open source as a hobby and allow them to 
   continue their work at a fully-funded, professional level. For 
   example, Chris Lamb and Ximin Luo, have been able to give 
   up their day job to focus exclusively on the Reproducible 
   Builds project.

so it now looks like that funds amounting to effective employment
are possible, too bad they never told me about it (this is of course
in direct contradiction to what they claimed in their blog and i
again give them permission to post any emails/etc that prove the
contrary). on a somewhat amusing sidenote, i can't help but notice
that someone at the CII must have taken lessons from the KSPP in
their copy-pasting skills as they managed to get Emese's last name
wrong not once but twice then repeated the same in their blog for
good measure.

so what do we have so far about this KSPP business? Google and
other companies made a decision to get our work upstream using
their own resources only - so far so good, it's their business
in every sense of the word. not involving us however turned out to
be an unwise decision when they realized that their employees are
completely unprepared for this work (we'll discuss some examples
later). this then led to all kinds of social engineering attempts
at trying to get us to help them out - all without getting paid
for our time, as if we were just supposed to drop all other work
and spend our free time on fixing their botched up attempts. as
if this still wasn't disgusting and outragous enough, they went
on the combative and had the guts to accuse us of not wanting
to cooperate without also mentioning that they expected all this
work from us for free taken away from our free time. at this point
it should be clear that the KSPP is anything but a community
project. rather, it's a joint effort of commercial companies
such as Google/Intel/etc to spend their corporate resources on
ripping our code and abusing our hard-earned reputation *and*
have the audacity to expect us to assist in all this using our
free time.

this state of affairs made us realize that if this is what this
'community' wants, then they shall get it. now they're on their
own and by looking at all the reactive mud slinging ever since,
they're terrified about the fate of their fork. based on the
level of incompetence they showed so far, it's not hard to see
why. this brings us to second part of our response where we'll
take a look at some of the claims Kees made and show them for
what they really are.

> It does underscore the critical need to upstream stuff, though.
> Forks of projects might disappear at any time. :(

this is somewhat rich coming from a Google employee considering
the fate of various linux forks used in their devices. one may
also wonder what will happen to the KSPP fork, especially now
that Fuchsia is also set to obsolete all that work and remove
the incentive to fund it much longer.

upstreaming stuff also isn't at all enough to prevent code
from disappearing, one needs to look no further than the recent
removal of avr32 support due to bitrot. considering the force
that sustains the KSPP (corporate money and interest) one can
guess how long said code will survive bitrot vs. our track
record that is the result of a fundamentally different kind of
motivation.

as another counterexample to why that 'critical need' can be
overrated, one can also look to the unprivileged ping code
(somewhat ironically, it's a security related feature, not
unlike the topic here), introduced on this very same list
years ago by Vasiliy Kulikov via a Google Summer of Code
project. it was later maintained by upstream developers who
then introduced several exploitable vulnerabilities in it.

> Additionally, while PaX Team, grsecurity, and ephox's work
> were technically separate development efforts (for example, just look
> at how PAX_USERCOPY differed between PaX and grsecurity),

FYI, USERCOPY wasn't separate efforts at all, we worked together
on USERCOPY and decided to carry certain features in grsec only.
this is a typical workflow for us, there've always been things that
started out in PaX and were made into a complete feature in grsec
or where i took back some code into PaX that i considered needed
infrastructure/features in there.

> Looking at the results in grsecurity, though, it's clear that they
> chose to integrate with upstream instead of maintaining a forked
> implementation.

i think you got that backwards, our code is the original, the KSPP
(and consequently upstream's) copy is just that, a fork (look at
where you get the gcc plugin updates from among others). that said,
why would we keep two similar copies of our own code around? as for
'integration', what i actually did was to clean up the mess you
created, just look at the bits i 'awarded' with CONFIG_BROKEN_SECURITY
and some more examples below.

> This is further supported by grsecurity being paid by CII to upstream
> the gcc plugin infrastructure,

correction, grsecurity, which according to your own definition is
a kernel patch, can't have been and thus never was paid by the CII,
Emese was (and she isn't a grsecurity developer any more than i am
an upstream linux developer).

> I think it's an entirely false claim that upstream is creating
> more work that normal forward porting.

and i think you're wrong on that (see below). it's in fact yet
another example to show your lack of understanding of what some
of our features do.

> Finally, even if you can somehow disregard the thousands of upstream
> changes benefiting grsecurity[...]

what exactly benefits *grsecurity* (you know, what you defined
as a kernel patch) and not kernel users in general (which then
means that said changes have nothing to do with us)? i can't think
of much if anything in recent memory.

> they have benefited from the upstreaming review by upstream
> finding bugs in various grsecurity features

oh yes, this myth that just can't die. we'll see in about a second
what exactly those 'bugs' are.

> Arnd Bergmann alone found tons of issues with the initify plugin
> and grsecurity fixed them)

actually that was something like 4 bugs in the plugin and we
didn't fix them, Emese did.

> Hardened usercopy found bugs in grsecurity's slab implementation,

now we're getting somewhere, let's dive in.

the first 'bug' was that *4.6* introduced red_left_pad to SLUB
objects which needs to be taken into account when computing
object boundaries and my code didn't. what you forgot to tell
the world at the time (and ever since) is that it was you who
took my code from *4.5* which didn't have red_left_pad and thus
was perfectly fine as is. the actual bug was that you blindly
copy-pasted my code (a recurring theme) without doing the one
job you had: maintain this code and follow upstream evolution.

the second 'bug' was the use of ksize vs. ->object_size which, if
memory serves, a slab maintainer insisted on using. what this
'bugfix' achieved in one fell swoop is that all SLUB objects with
padding can now be used to leak that padding which pretty much
destroys the purpose of (your copy of) USERCOPY. just think about
it, by definition that padding is uninitialized memory and thus a
prime target for memory leak attempts that thanks to your 'bugfix'
can now occur unimpeded. as an aspiring maintainer your proper
response should have been to explain this to the slab maintainers
and also why ksize is an abomination itself (its users by definition
exercise UB) and that the problem it sets out to solve should be
an API redesign instead (remove ksize and create a new allocation
function that takes the size as reference and updates it on return
so that the caller can learn how much memory it ended up getting).

so that's two bugs so far, except none of them is ours but yours
instead but nice try selling them otherwise. unfortunately the
buck doesn's stop just there yet, there're more problems with
this expert reviewed and maintained code (i wonder how on earth
we managed to survive this far without such expertise).

the third bug is that the comment describing __check_heap_object
is meaningless garbage as already allocated objects by definition
cannot be 'incorrectly sized' (at least not at this level,
SIZE_OVERFLOW would be something closer to that purpose) and of
course the purpose of USERCOPY has nothing to do with verifying
object sizes anyway. what USERCOPY does want to verify is the
size of the memory *copy* attempt (that is, the copy must fully
fall inside the kernel object).

this brings us to the fourth bug which is the verification of the
kernel object pointer for being 'impossible'. that of course was
never the purpose of USERCOPY as its design assumes a threat
model where an attacker controls only the size of the copy but
not the object pointer. if the latter is also assumed, all bets
are off, there's no way such checks can catch an actual attack
(checking pointer provenance is a very hard problem).

there're further problems caused by your 'improvements' on our
code. one is the needless change of the log message that breaks
existing log analyzers looking for a pattern. the other problem
is that the replacement of do_group_exit with a BUG is entirely
unnecessary as a USERCOPY event is recoverable, there's no need
to panic the whole system because of it (a bit like how a REFCOUNT
event is recoverable to an extent). i also wonder what locks would
be broken by BUG when copy*user functions can sleep and thus are
not supposed to be called under locks anyway. (and if you didn't
mean spinlocks then how would BUG handling break them?)

last but not least, a quick look at your claim to fame due to:

> [USERCOPY] gained strncpy_from_user() coverage [...]

this is an entirely pointless exercise as an audit of the few
callers of said function can show their correctness instead. so 
your 'coverage' adds nothing but pointless performance impact
to it. FWIW, similar considerations made us not check copying
with compile-time constant sizes at the time.

i believe this brief overview at your achievements regarding
USERCOPY shows that instead of fixing any bugs in our code, you
in fact added a bunch of them.

> The current refcount_t work based on PAX_REFCOUNT uncovered a
> crash bug in grsecurity's implementation

for the record, it was a bug introduced in the PaX 4.9 port only
and you failed to spot it when copying it to a newer kernel (you
also failed to notice what the underlying problem i wanted to fix
was and thus didn't fix it yourself either at the time). note also
that the reporting problem i tried to fix there (and fixed it
differently in later patches) is still not properly addressed in
your refcount port but at least you documented it now.

> Upstreaming grsecurity features brings a huge amount of testing
> to bear on the code, which, like all the other things in upstream,
> grsecurity directly benefits from.

not all things upstreamed benefit us (or other users for that matter).
just look at VMAP_STACK (upstream NIH'd version of Brad's KSTACKOVERFLOW
feature) and the entirely avoidable damage (and security bugs) it
caused to end users ever since its release.

> And to top all of this off, while upstreaming the latent_entropy
> plugin, I noticed a English typo that was present in all the
> grsecurity gcc plugins, and when I sent them a trivial spelling
> fix patch for all their plugins[...]

if only it had been all plugins... clearly you never tried a recursive
grep and thus missed the same typo in RAP and SIZE_OVERFLOW.

> [...] (rather than just letting it stand and making work for
> them to catch it during forward porting and fix it everywhere
> else), they publicly mocked the patch (which they applied).

given the above, it'd have been better to just send an email about
the typo and let us fix it ourselves properly which we ended up
doing anyway instead of using your incomplete patch.

> Upstreaming can be extremely time consuming. Grsecurity made it clear
> from long ago that they had no intention of upstreaming things because
> they wanted to use their time differently.

not true at all. what we've always said was that upstreaming our
code requires so much time that noone can reasonably expect us to
do it in our free time. that the KSPP exists entirely by corporate
decree is proof of that. what would actually limit any potential
upstreaming effort on our side is the need to balance our time
spent on upstreaming vs. time spent on new R&D. come to think of
it, if the companies running the KSPP had played it smart, they'd
have gone out of their way to engage us as that's the only way
they'd have a chance to close the ever widening feature gap.

> That said, when I asked grsecurity if there I was any way they would
> accept payment to upstream things, they did briefly agree and
> upstreamed the gcc plugin infrastructure. So they were willing to
> upstream if paid, yet ultimately decided to stop, and to continue to
> forward port their patches.

i don't know who you asked as 'grsecurity' but the only thing i
recall was some private conversations back in 2015 where you
suggested to try to get the CII to fund an upstreaming project
(where you yourself had no saying) and that turned out to be a
downer. you also knew full well that Brad wouldn't have anything
to do with the CII due to one of their member companies (that
entirely coincidentally is also behind the KSPP) having violated
his trademark. one can't also help but wonder why you didn't
offer Google's money? because you have never been authorized by
Google to act on their behalf (and thus can't have possibly made
any such offers)? so i'm not sure what you think you did to get
us 'accept payment to upstream things' but you've clearly never
been in a position to make such an offer (and no, poorly disguised
social engineering attempts don't count).

by the way, it wasn't Brad who upstreamed the gcc plugins stuff
but Emese (she's neither a PaX nor a grsecurity developer).

> [...] I again summarily reject the notion that upstreaming
> grsecurity features creates "more work for grsecurity without
> value in return".
> [...]
> To your specific examples, __ro_after_init is literally a one-line
> change: they just make in __read_only. This was some of my first
> attempts to make their forward porting work easy while upstream slowly
> incorporated features.

this is false and only shows that you don't at all understand what
__read_only really does. in particular, __read_only is enforced
much earlier in modules (so much for it being 'after init') and
thus all writes to such objects must be instrumented. this means
that all new __ro_after_init uses must be carefully audited and
any writes to them instrumented. this is anything but 'literally
a one-line change' (though i can at least get the compiler to do
the work for me to an extent).

> The work around PAX_MEMORY_SANITIZE made the slab debug paths
> faster for everyone.

i wonder, how many systems actually enable those slab debug features
at runtime due to their performance impact.

> So, neither of us can speak for grsecurity, but I reject your belief
> that upstream has somehow created needless work for them.

fortunately it's got nothing to do with belief but simple facts
that happen to contradict your belief.

> Which brings me to a question I haven't seen anyone ask yet: why does
> grsecurity exist?

thanks for your concern for our existence but i think you should
ask why the KSPP exists instead and how much longer it will be
around. based on your statements here and in later mails it seems
that you're very worried that your ability to copy-paste yet more
of our code will diminish over time. unfortunately for you, putting
up a fake happy face and pretending nothing happened won't actually
make it any better for the KSPP.

back to your question, you don't have to guess and can instead just
look at what world class domain experts think of our work in their
testimonials on the grsecurity website. it seems to me that you and
the KSPP are stuck in the world of linux whereas our work has
affected much more than that already. so in a sense you're right to
say that we don't care about all linux users since we actually care
about everyone else too and use our projects (the code, conference
presentations, blogs, etc) to showcase defense technologies that
everyone can benefit from, not just linux users. when will the KSPP
reach this level, if it's on the corporate agenda all, that is? and
if all this counts for nothing for you then consider our existence
as the apparent enabler of your career.

> You're speaking entirely in theoreticals, but I understand what you're
> trying to say. All forward porting runs this risk. Kernel internals
> change in ways that threaten even unchanged grsecurity features. To
> bring this down to earth, I would ask "how does grsecurity perform
> testing?" I can point to the many ways how upstream performs testing,
> including LKDTM for several of the security-sensitive features. As
> seen in the PAX_REFCOUNT porting work, the 4.9 grsecurity patch was
> clearly never actually tested since _any_ exercise of the PAX_REFCOUNT
> protection would Oops the kernel.

you're wrong, i actually tested the code just not a last-minute
one-liner change that was 'obviously correct' (well, it wasn't,
it happens). on the other hand it's pretty funny that you pointed
out this one bug as it was you who blindly copy-pasted it *and*
never tested it yourself otherwise you would have found it, not
Jann Horn. another funny thing is that you clearly never understood
the REFCOUNT reporting code as LKDTM didn't even exercise those
paths at the time. last but not least, the actual effect of the
bug wasn't necessarily an oops, it all depended on how the offsets
were encoded in the conditional jumps (as i explained all this in
my response to Jann and you).

> [...] but I can point you directly to how upstream tests, how upstream
> developers find bugs in grsecurity features, and how things can improve =
once
> upstreamed (again, for example, the massive uaccess consolidation).

yep, things improve indeed, like the new vulnerabilities caused by
ping sockets, VMAP_STACK, HARDENED_USERCOPY, SLAB_FREELIST_RANDOM,
HARDENED_REFCOUNT, etc...

> I think I have thoroughly disproved this position. Something that I
> think is hard to see for people not involved in day-to-day upstream
> work is how very different the development workflows are between
> upstream and grsecurity. Upstream is normally evolutionary, doing
> things in easy to digest pieces, where as grsecurity could just land
> massive changes between releases.

believe it or not but we also develop our features step-by-step, not
unlike how any sane developer, upstream or not, does it.

> These are all complaints to be made to grsecurity. They are the ones
> who provides those features originally, did not upstream them, and
> then took them away.

i'm wondering, when are you going to stop the hypocrisy and this
rhetoric of blaming us for not upstreaming our own code in our free
time while the KSPP companies have been happily paying you and
others for doing the same?

> > So, here's my list of questions for the KSPP:
> > 1/ When will I be able to switch to a vanilla Linux kernel that is
> > equivalently hardened as a grsecurity/PaX kernel used to be?
> 
> How could anyone answer that question? I can't see the future.

well, it seems that not that long ago you did see the future as:

  grsec is going to stay a decade ahead of anyone else (not just Linux)

> And besides, it's not like grsecurity was providing comprehensive
> protections. If you're using arm64, you might feel like you're already
> in a better position with upstream (got PAN emu, got hardened
> usercopy, still no RAP).

actually, by definition you can't be in a better position with
upstream unless you're claiming that we actually reduce security
with our code (please, do bring up my disabling of KASLR, happy
to discuss it again). in fact due to the bugfixes we have for
your USERCOPY fork (that is, we kept our own working code), our
code *is* actually in a better position already.

as for RAP, it works on any arch by design, i just don't enable it
on archs where i haven't fixed all the function pointer abuse yet
and marked up asm code (both arm and arm64 work already here).

> Upstream's goal is protecting as many people as possible.

the KSPP's goal is to further the agenda of the companies behind
it (which is extracting profits for shareholders). that has nothing
to do with "protecting as many people as possible" but everything
to do with business goals du jour. if what you claim was true,
they would have done it since the beginning and in a way that is
not restricted to only linux users.

> > 2/ Who will maintain this code and how?
> > 3/ Who ensures the coverage and quality won't suffer for each new
> > kernel release?
> 
> The upstream development community, just like everything else. I
> answered both of these already above.

the correct answer is 'whoever the KSPP companies put on the job'
though their performance so far doesn't leave one with great
confidence as to the sustainability of the project.

cheers till the next round,
 PaX Team
