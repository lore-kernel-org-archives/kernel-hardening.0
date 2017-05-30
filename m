References: <20170529213800.29438-1-matt@nmatt.com>
 <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop>
 <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
 <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
 <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
 <20170530132427.016053da@alans-desktop>
 <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <1496169122.2164.21.camel@tycho.nsa.gov>
 <CAFJ0LnHKKccbr-LqHHaFX5UNB20DzqfWDhvR-NTpgPedtkg0RA@mail.gmail.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <100b7d8c-7468-3122-4f59-3b0dcdf5dfc3@nmatt.com>
Date: Tue, 30 May 2017 14:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFJ0LnHKKccbr-LqHHaFX5UNB20DzqfWDhvR-NTpgPedtkg0RA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Nick Kralevich <nnk@google.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 5/30/17 2:44 PM, Nick Kralevich wrote:
> On Tue, May 30, 2017 at 11:32 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>> Seccomp requires the program in question to "opt-in" so to speak and
>>> set
>>> certain restrictions on itself. However as you state above, any
>>> TIOCSTI
>>> protection doesn't matter if the program correctly allocates a
>>> tty/pty pair.
>>> This protections seeks to protect users from programs that don't do
>>> things
>>> correctly. Rather than killing bugs, this feature attempts to kill an
>>> entire
>>> bug class that shows little sign of slowing down in the world of
>>> containers and
>>> sandboxes.
>>
>> Just FYI, you can also restrict TIOCSTI (or any other ioctl command)
>> via SELinux ioctl whitelisting, and Android is using that feature to
>> restrict TIOCSTI usage in Android O (at least based on the developer
>> previews to date, also in AOSP master).
> 
> For reference, this is https://android-review.googlesource.com/306278
> , where we moved to a whitelist for handling ioctls for ptys.
> 
> -- Nick
> 

Thanks, I didn't know that android was doing this. I still think this feature
is worthwhile for people to be able to harden their systems against this attack
vector without having to implement a MAC.

Matt
