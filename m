MIME-Version: 1.0
From: Raj Brar <rarbrar.32@gmail.com>
Date: Thu, 29 Jun 2017 04:18:09 +0530
Message-ID: <CABJDFStSohQPzt+u1u8Fd8w1DEhTzL+Md8M=en1Jzogt9CnOqQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="94eb2c0619026e69a505530cfa5f"
Subject: [kernel-hardening] My mail to the grsecurity team to expose their FUD
To: kernel-hardening@lists.openwall.com
Cc: spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c0619026e69a505530cfa5f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Spender,

I would have wrote this earlier, but I didn=E2=80=99t sum up the patience a=
nd the
will to write this up until I read a comment on grsecurity forums. I am an
old Grsecurity user on Gentoo and Archlinux. Over the years the work you
did on grsecurity has been unparalleled and unmatched in upping the
security of the Linux Kernel, something they (The Linux Foundation &
Torvalds) have failed to address since its inception. I have always
benefited from grsecutity=E2=80=99s PAX features in my personal work statio=
ns and
development environments.

Now let us go back a little. Back in August 26, 2015 I hear the news that
you have decided to make the -stable patches of grsecurity unavailable for
the general public. The reasons stated by your were as follows : =E2=80=9CI=
t turns
out that not everyone played nice, in particular several very large
companies in the embedded Linux world who have gone beyond simply taking
advantage of our work.=E2=80=9D =E2=80=93 https://grsecurity.net/announce.p=
hp . The said
company did violate your registered Trademarks by using the grsecurity name
in their products and I really believed you deserved your share of respect
and appreciation and wanted an alternative paying user base for your
-stable patches. You said you had little chance to remedy the situation
through legal action against a =E2=80=9Cmulti-billion dollar corporation=E2=
=80=9D with a
huge legal team. You decided that it was unfair to your sponsors that the
above mentioned unlawful players can get away with their activity.
Therefore you ceased the public dissemination of the stable series and made
it available to =E2=80=9Ccommercial customers only=E2=80=9D. At that time, =
I did feel
sympathetic towards you as you said you spent =E2=80=98thousands of dollars=
 on
legal fees challenging the embedded Linux industry=E2=80=99 and the above m=
easure
may just compensate your efforts, yet keeping the distro community like
Gentoo and Archlinux happy with your -test patches. As a user this move
didn=E2=80=99t affect me as such even though I prefer to use the LTS series=
 of the
upstream Linux Kernel for which your -stable patches were the best.

So far so good. Little did I know that this was Stage 1 to your bigger
plans. Fast forward to this day I hear you have upped your =E2=80=98blame g=
ame=E2=80=99 and
cut down public access to your test patches too. The whole KSPP =E2=80=98ri=
p off=E2=80=99
and =E2=80=9Cbillion dollar corporations=E2=80=9D exploiting your work and =
expecting
additional free work out of you. Yes, I agree what the Kees/Greg/etc were
doing to you was =E2=80=98unfair=E2=80=99. But, given your product is under=
 the GNU GPL,
let me take the privilege to explain you briefly what the GPL stands for.
The universal narrative behind the GPL as explained by the FSF =E2=80=98Cre=
ator
behind the license you use in your patch=E2=80=99 is this :

Freedom 0: The freedom to *run* the program for any purpose.

Freedom 1: The freedom to *study* how the program works, and change it to
make it do what you wish.

Freedom 2: The freedom to *redistribute* and make copies so you can help
your neighbor.

Freedom 3: The freedom to *improve* the program, and release your
improvements (and modified versions in general) to the public, so that the
whole community benefits.

I can=E2=80=99t help but focus on Freedom 2 and 3 in the case of grsecurity=
 and
your accusations for other individuals and companies =E2=80=9Cstealing and
exploiting=E2=80=9D your work. The basic essence of the GPL is to legitimis=
e the
idea of =E2=80=98sharing=E2=80=99 and not demonizing or re-spinning it as =
=E2=80=98STEALING /
EXPLOITING /PIRATING=E2=80=99 as you make it sound like; be it a small indi=
vidual
or by =E2=80=9Cbillion dollar corporations=E2=80=9D. Yes, I do agree =E2=80=
=98Misusing Trademark
and quality=E2=80=99 is a different debate which I am not getting into but =
let=E2=80=99s
focus on this specific aspect for now.

Let me give you few working examples of this model of =E2=80=98sharing=E2=
=80=99 / =E2=80=98a.k.a
EXPLOITING as per your interpretation=E2=80=99 to you from within the free =
software
community. As we all know the Ubuntu Linux distribution is based on
Debian=E2=80=99s Unstable branch. Ubuntu is a product by Canonical Ltd.. Ub=
untu
somewhat cooperates with Debian by pushing changes back to the Debian
community, although there has been criticism that this does not happen
often enough. The Debian community and Late. Ian Murdock had expressed
concerns in the past regarding this too. A =E2=80=9Cmillion dollar corporat=
ion=E2=80=9D
Canonical Ltd. charges by selling commercial support to Ubuntu Customers by
selling support services and training programs. But they don=E2=80=99t shar=
e this
revenue with the Debian community; their original upstream. Was this
=E2=80=98unfair=E2=80=99 from Canonical=E2=80=99s end ? Yes, It was. Did De=
bian =E2=80=98whine=E2=80=99 about it or
shut its doors to the general public? No. Allow me to give another example.
The Fedora Distribution of Linux is a community project that a =E2=80=9Cbil=
lion
dollar corporation=E2=80=9D like Redhat benefits from by downstreaming and =
selling
an enterprise product based on Fedora, The Redhat Enterprise Linux (RHEL).
Is it =E2=80=98sort of=E2=80=99 unfair of Redhat to profit from a community=
 work like
Fedora? Yes. Are the developers of the Fedora Project hired Redhat
employees? No. But they don=E2=80=99t whine and moan and believe in their g=
ood work
over =E2=80=98recognition=E2=80=99. We also have Oracle Linux that is compi=
led entirely
from Red Hat Enterprise Linux=E2=80=99s source code, replacing Red Hat bran=
ding by
Oracle's. Oracle gets to profit from this product by selling support
services. Did Redhat sue Oracle for doing this? No. The cases above clearly
portray that =E2=80=98unfair=E2=80=99 practises do not necessarily mean =E2=
=80=98STEALING CODE=E2=80=99 or
the violation of the GPL or the spirit of free software. The GPL in
actually stands for =E2=80=98nullifying=E2=80=99 the very branding and term=
ing of
=E2=80=98stealing=E2=80=99 from the Free Software world. Tell me honestly d=
ear Spender, do
you really connect with the idea of the GPL or do you use this as a PR
exercise to please your =E2=80=98Paid Sponsors=E2=80=99? You could have sim=
ply let the KSPP
project continue with their crappy rip-off by ignoring them and keep on
letting users and community benefiting from your quality work. Instead you
have used this as a long-waited Stage 2 opportunity coming from your long
awaited greed =E2=80=98Which I will explain shortly=E2=80=99 to do what you=
 always wanted
to do, yet cultivate enough sympathy to avoid any backlash.

In your post =E2=80=98passing the baton=E2=80=99 you felt grateful and have=
 credited the
Hardened-Gentoo linux project with your =E2=80=98all of the mostly
under-appreciated and uncredited work by Gentoo Hardened to push through
widespread use of PIE and fixing userland to handle the stricter memory
defenses of PaX (which SELinux and others were later able to benefit from).
Specifically, we'd like to thank Mike Frysinger, Anthony Basile, Ned Ludd,
Peter S. Mazinger, and Alexander Gabert for their Gentoo Hardened work and
forum user meev0 for the majority of the grsecurity wiki.=E2=80=99 Really? =
If you
are so =E2=80=98grateful=E2=80=99 to them for the widespread adaptation of =
Grsecurity that
gave you such fame and popularity to whine on, what did you give them back
in return? You also give your =E2=80=98heartfelt gratitude to the users who=
 have
supported your public work through donations or otherwise over the past 16
years.=E2=80=99 What did you give them back in return? Did you give them co=
ntinued
access to your test patches at the very minimum as a token of gratitude for
helping in widespread adaptation of your project? Why do you speak and
appease things you don=E2=80=99t actually mean? I may hate Linus Torvalds a=
s a
person, but feel the comments he made when he said =E2=80=98When they start=
ed
talking about people taking advantage of them, I stopped trying to be
polite about their bullshit.=E2=80=99. Clearly people have started looking =
through
your facade of playing the =E2=80=98Victim Card=E2=80=99.

Throughout the mail I have used double quotes to refer to =E2=80=9Cmulti-bi=
llion
dollar corporation=E2=80=9D. This was done deliberately to highlight someth=
ing. As
per https://grsecurity.net/purchase.php the subscription to grsecurity
patches are only for companies as it is a (** required field). To highlight
the damage you have done under the guise of your =E2=80=98Playing the Victi=
m Card=E2=80=99
allow me to quote a post from the grsecurity forums which you have opted to
ignore : =E2=80=9CI'm using test patches on my home PC. I live in country w=
ith low
average wage. I can't move to country with higher wages because of
barriers.=E2=80=9D. Clearly by your actions you have done greater damage to=
 users
and machines that are presently using grsec=E2=80=99s last patches. There a=
re
actually users who can=E2=80=99t afford to pay for your unreasonable charge=
s who do
have a =E2=80=98right=E2=80=99 to benefit from your work. Given your paid s=
ubscriptions are
meant for =E2=80=98Companies=E2=80=99 only, one can very well guess they ar=
e not cheap and
once again you prove my point. You have opted to deep throat and to be in
bed with the very same =E2=80=9Cmulti-billion dollar corporations=E2=80=9D =
you accuse and
whine of =E2=80=9Cstealing=E2=80=9D and =E2=80=9Cexploiting=E2=80=9D your p=
roject for which I constantly
kept double-quoting the very phrase. And even if some organisation or
company pays for a subscription and decides to share your patches to the
community by exercising its GPL rights, I am pretty sure you will cut off
their subscription in the pretext of =E2=80=98Exploited us=E2=80=99.

You may argue that grsecurity is your project and you hold the exclusive
rights to decide its fate and I have no business in dictating what you
should do with it. Sure, that=E2=80=99s true, I honestly have no problem wi=
th that.
The only reason I felt that =E2=80=98itch=E2=80=99 to write this e-mail was=
 cause I was
disgusted by your sheer hypocrisy against =E2=80=9Cmulti-billion dollar
corporations=E2=80=9D whereas the sheer irony is you serve to them by selli=
ng the
product to Companies and playing the =E2=80=98Victim Card=E2=80=99 since 20=
15.

Here is what you should do :

a) Re-license grsecurity under a proprietary EULA as you don=E2=80=99t have=
 a clear
understanding or genuine connection with the idea behind the GNU GPL, and
to not sound like a hypocrite and spare the GPL world of any
misunderstanding. You should stop insulting the free software world and the
communities behind it by doing so. I guess your hands have started itching
to do this already, all you are looking for is another excuse and careful
timing as we speak may be?

b) Amend the faq section of =E2=80=98Why are you *really* doing this?=E2=80=
=99 in
https://grsecurity.net/passing_the_baton_faq.php and clearly mention the
=E2=80=9CActual Reason=E2=80=9D and regarding your long decided plan for cl=
osing your
project instead of yet another =E2=80=98advertisement=E2=80=99 of your prod=
uct=E2=80=99s
superiority. Suggestions? =E2=80=9CI have been consumed in greed and ambiti=
on and
needed a way to make money out of my project. To avoid any subsequent
backlash to me and my respected PR team, I carefully timed the decision and
the reason.=E2=80=9D.

c) Apologise to the gentoo-hardened community and the previous users of the
grsecurity who helped your project to gain prominence for using them as a
leverage for your commercial interests.


The funny thing is, your actions will cause you more damage than you can
foresee. A crappy/ inferior project like KSPP will reign in popularity soon
due to its widespread public availability whereas you will start start
rotting down in the ash heap of history where noone gives a shit about your
whining.

I will close this mail with a suggestion, instead of trying to attack me
publicly by calling me a troll and other mechanisms of public manipulation,
take a few days, think on this mail, let it sink in and understand that
there will always be people who can look past you. I will make sure I
spread this mail in public community forums and reddit so that people start
looking past you.

Yours Not So Sincerely,

A Free User.

--94eb2c0619026e69a505530cfa5f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p style=3D"margin-bottom:0.5cm;line-height:100%" align=3D=
"justify">Dear
Spender,</p>
<p style=3D"margin-bottom:0.5cm;line-height:100%" align=3D"justify">I
would have wrote this earlier, but I didn=E2=80=99t sum up the patience and
the will to write this up until I read a comment on grsecurity
forums. I am an old Grsecurity user on Gentoo and Archlinux. Over the
years the work you did on grsecurity has been unparalleled and
unmatched in upping the security of the Linux Kernel, something they
(The Linux Foundation &amp; Torvalds) have failed to address since
its inception. I have always benefited from grsecutity=E2=80=99s PAX
features in my personal work stations and development environments.<br></p>=
<p style=3D"margin-bottom:0.5cm;line-height:100%" align=3D"justify">Now
let us go back a little. Back in August 26, 2015 I hear the news that
you have decided to make the -stable patches of grsecurity
unavailable for the general public. The reasons stated by your were
as follows : =E2=80=9CIt turns out that not everyone played nice, in
particular several very large companies in the embedded Linux world
who have gone beyond simply taking advantage of our work.=E2=80=9D =E2=80=
=93=20
<a target=3D"_blank" href=3D"https://grsecurity.net/announce.php">https://g=
rsecurity.net/<wbr>announce.php</a>
. The said company did violate your registered Trademarks by using
the grsecurity name in their products and I really believed you
deserved your share of respect and appreciation and wanted an
alternative paying user base for your -stable patches. You said you
had little chance to remedy the situation through legal action
against a =E2=80=9Cmulti-billion dollar corporation=E2=80=9D with a huge le=
gal
team. You decided that it was unfair to your sponsors that the above
mentioned unlawful players can get away with their activity.
Therefore you ceased the public dissemination of the stable series
and made it available to =E2=80=9Ccommercial customers only=E2=80=9D. At th=
at
time, I did feel sympathetic towards you as you said you spent
=E2=80=98thousands of dollars on legal fees challenging the embedded Linux
industry=E2=80=99 and the above measure may just compensate your efforts,
yet keeping the distro community like Gentoo and Archlinux happy with
your -test patches. As a user this move didn=E2=80=99t affect me as such
even though I prefer to use the LTS series of the upstream Linux
Kernel for which your -stable patches were the best.=20

</p><p style=3D"margin-bottom:0.5cm;line-height:100%" align=3D"justify">So
far so good. Little did I know that this was Stage 1 to your bigger
plans. Fast forward to this day I hear you have upped your =E2=80=98blame
game=E2=80=99 and cut down public access to your test patches too. The
whole KSPP =E2=80=98rip off=E2=80=99 and =E2=80=9Cbillion dollar corporatio=
ns=E2=80=9D
exploiting your work and expecting additional free work out of you.
Yes, I agree what the Kees/Greg/etc were doing to you was =E2=80=98unfair=
=E2=80=99.
But, given your product is under the GNU GPL, let me take the
privilege to explain you briefly what the GPL stands for. The
universal narrative behind the GPL as explained by the FSF =E2=80=98Creator
behind the license you use in your patch=E2=80=99 is this :</p>
<p style=3D"margin-bottom:0.5cm" align=3D"justify">Freedom 0: The
freedom to <b>run</b> the program for any purpose.=20
</p>
<p style=3D"margin-bottom:0.5cm" align=3D"justify">Freedom 1: The
freedom to <b>study</b> how the program works, and change it to make
it do what you wish.=20
</p>
<p style=3D"margin-bottom:0.5cm" align=3D"justify">Freedom 2: The
freedom to <b>redistribute</b> and make copies so you can help your
neighbor.=20
</p>
<p style=3D"margin-bottom:0.5cm" align=3D"justify">Freedom 3: The
freedom to <b>improve</b> the program, and release your improvements
(and modified versions in general) to the public, so that the whole
community benefits.=20
</p>
<p>I can=E2=80=99t help but focus on Freedom 2 and 3 in the case of
grsecurity and your accusations for other individuals and companies
=E2=80=9Cstealing and exploiting=E2=80=9D your work. The basic essence of t=
he GPL
is to legitimise the idea of =E2=80=98sharing=E2=80=99 and not demonizing o=
r
re-spinning it as =E2=80=98STEALING / EXPLOITING /PIRATING=E2=80=99 as you =
make
it sound like; be it a small individual or by =E2=80=9Cbillion dollar
corporations=E2=80=9D. Yes, I do agree =E2=80=98Misusing Trademark and qual=
ity=E2=80=99
is a different debate which I am not getting into but let=E2=80=99s focus
on this specific aspect for now.=20
</p>
<p>Let me give you few working examples of this model of =E2=80=98sharing=
=E2=80=99
/ =E2=80=98a.k.a EXPLOITING as per your interpretation=E2=80=99 to you from
within the free software community. As we all know the Ubuntu Linux
distribution is based on Debian=E2=80=99s Unstable branch. Ubuntu is a
product by Canonical Ltd.. Ubuntu somewhat cooperates with Debian by
pushing changes back to the Debian community, although there has been
criticism that this does not happen often enough. The Debian
community and Late. Ian Murdock had expressed concerns in the past
regarding this too. A =E2=80=9Cmillion dollar corporation=E2=80=9D Canonica=
l Ltd.
charges by selling commercial support to Ubuntu Customers by selling
support services and training programs. But they don=E2=80=99t share this
revenue with the Debian community; their original upstream. Was this
=E2=80=98unfair=E2=80=99 from Canonical=E2=80=99s end ? Yes, It was. Did De=
bian =E2=80=98whine=E2=80=99
about it or shut its doors to the general public? No. Allow me to
give another example. The Fedora Distribution of Linux is a community
project that a =E2=80=9Cbillion dollar corporation=E2=80=9D like Redhat ben=
efits
from by downstreaming and selling an enterprise product based on
Fedora, The Redhat Enterprise Linux (RHEL). Is it =E2=80=98sort of=E2=80=99
unfair of Redhat to profit from a community work like Fedora? Yes.
Are the developers of the Fedora Project hired Redhat employees? No.
But they don=E2=80=99t whine and moan and believe in their good work over
=E2=80=98recognition=E2=80=99. We also have Oracle Linux that is compiled
entirely from Red Hat Enterprise Linux=E2=80=99s source code, replacing Red
Hat branding by Oracle&#39;s. Oracle gets to profit from this product by
selling support services. Did Redhat sue Oracle for doing this? No.
The cases above clearly portray that =E2=80=98unfair=E2=80=99 practises do =
not
necessarily mean =E2=80=98STEALING CODE=E2=80=99 or the violation of the GP=
L or
the spirit of free software. The GPL in actually stands for
=E2=80=98nullifying=E2=80=99 the very branding and terming of =E2=80=98stea=
ling=E2=80=99 from
the Free Software world. Tell me honestly dear Spender, do you really
connect with the idea of the GPL or do you use this as a PR exercise
to please your =E2=80=98Paid Sponsors=E2=80=99?  You could have simply let =
the
KSPP project continue with their crappy rip-off by ignoring them and
keep on  letting users and community benefiting from your quality
work. Instead you have used this as a long-waited Stage 2 opportunity
coming from your long awaited greed =E2=80=98Which I will explain shortly=
=E2=80=99
to do what you always wanted to do, yet cultivate enough sympathy to
avoid any backlash.=20

</p><p>In your post =E2=80=98passing the baton=E2=80=99 you felt grateful a=
nd have
credited the Hardened-Gentoo linux project with your =E2=80=98all of the
mostly under-appreciated and uncredited work by Gentoo Hardened to
push through widespread use of PIE and fixing userland to handle the
stricter memory defenses of PaX (which SELinux and others were later
able to benefit from). Specifically, we&#39;d like to thank Mike
Frysinger, Anthony Basile, Ned Ludd, Peter S. Mazinger, and Alexander
Gabert for their Gentoo Hardened work and forum user meev0 for the
majority of the grsecurity wiki.=E2=80=99 Really? If you are so =E2=80=98gr=
ateful=E2=80=99
to them for the widespread adaptation of Grsecurity that gave you
such fame and popularity to whine on, what did you give them back in
return? You also give your =E2=80=98heartfelt gratitude to the users who
have supported your public work through donations or otherwise over
the past 16 years.=E2=80=99 What did you give them back in return? Did you
give them continued access to your test patches at the very minimum
as a token of gratitude for helping in widespread adaptation of your
project? Why do you speak and appease things you don=E2=80=99t actually
mean? I may hate Linus Torvalds as a person, but feel the comments he
made when he said =E2=80=98When they started talking about people taking
advantage of them, I stopped trying to be polite about their
bullshit.=E2=80=99. Clearly people have started looking through your facade
of playing the =E2=80=98Victim Card=E2=80=99.=20

</p><p>Throughout the mail I have used double quotes to refer to
=E2=80=9Cmulti-billion dollar corporation=E2=80=9D. This was done deliberat=
ely to
highlight something. As per <a target=3D"_blank" href=3D"https://grsecurity=
.net/purchase.php">https://grsecurity.net/<wbr>purchase.php</a>
the subscription to grsecurity patches are only for companies as it
is a (** required field). To highlight the damage you have done under
the guise of your =E2=80=98Playing the Victim Card=E2=80=99 allow me to quo=
te a
post from the grsecurity forums which you have opted to ignore : =E2=80=9CI=
&#39;m
using test patches on my home PC. I live in country with low average
wage. I can&#39;t move to country with higher wages because of
barriers.=E2=80=9D. Clearly by your actions you have done greater damage to
users and machines that are presently using grsec=E2=80=99s last patches.
There are actually users who can=E2=80=99t afford to pay for your
unreasonable charges who do have a =E2=80=98right=E2=80=99 to benefit from =
your
work. Given your paid subscriptions are meant for =E2=80=98Companies=E2=80=
=99
only, one can very well guess they are not cheap and once again you
prove my point. You have opted to deep throat and to be in bed with
the very same =E2=80=9Cmulti-billion dollar corporations=E2=80=9D you accus=
e and
whine of =E2=80=9Cstealing=E2=80=9D and =E2=80=9Cexploiting=E2=80=9D your p=
roject for which I
constantly kept double-quoting the very phrase. And even if some
organisation or company pays for a subscription and decides to share
your patches to the community by exercising its GPL rights, I am
pretty sure you will cut off their subscription in the pretext of
=E2=80=98Exploited us=E2=80=99.=20

</p><p>You may argue that grsecurity is your project and you hold the
exclusive rights to decide its fate and I have no business in
dictating what you should do with it. Sure, that=E2=80=99s true, I honestly
have no problem with that. The only reason I felt that =E2=80=98itch=E2=80=
=99 to
write this e-mail was cause I was disgusted by your sheer hypocrisy
against =E2=80=9Cmulti-billion dollar corporations=E2=80=9D whereas the she=
er
irony is you serve to them by selling the product to Companies and
playing the =E2=80=98Victim Card=E2=80=99 since 2015.
</p><p>Here is what you should do :
</p><p>a) Re-license grsecurity under a proprietary EULA as you don=E2=80=
=99t
have a clear understanding or genuine connection with the idea behind
the GNU GPL, and to not sound like a hypocrite and spare the GPL
world of any misunderstanding. You should stop insulting  the free
software world and the communities behind it by doing so. I guess
your hands have started itching to do this already, all you are
looking for is another excuse and careful timing as we speak may be?
</p><p>b) Amend the faq section of =E2=80=98Why are you <em>really</em> doi=
ng
this?=E2=80=99 in <a target=3D"_blank" href=3D"https://grsecurity.net/passi=
ng_the_baton_faq.php">https://grsecurity.net/<wbr>passing_the_baton_faq.php=
</a>
and clearly mention the =E2=80=9CActual Reason=E2=80=9D and regarding your =
long
decided plan for closing your project instead of yet another
=E2=80=98advertisement=E2=80=99 of your product=E2=80=99s superiority. Sugg=
estions? =E2=80=9CI
have been consumed in greed and ambition and needed a way to make
money out of my project. To avoid any subsequent backlash to me and
my respected PR team, I carefully timed the decision and the
reason.=E2=80=9D.
</p><p>c) Apologise to the gentoo-hardened community and the previous
users of the grsecurity who helped your project to gain prominence
for using them as a leverage for your commercial interests.
</p><p><br>
The funny thing is, your actions will cause you more damage than
you can foresee. A crappy/ inferior project like KSPP will reign in
popularity soon due to its widespread public availability  whereas
you will start start rotting down in the ash heap of history where
noone gives a shit about your whining.=20

</p><p>I will close this mail with a suggestion, instead of trying to
attack me publicly by calling me a troll and other mechanisms of
public manipulation, take a few days, think on this mail, let it sink
in and understand that there will always be people who can look past
you. I will make sure I spread this mail in public community forums
and reddit so that people start looking past you.
</p><p>Yours Not So Sincerely,=20

</p><p>A Free User.</p></div>

--94eb2c0619026e69a505530cfa5f--
