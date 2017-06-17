References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-7-Jason@zx2c4.com>
 <20170608024357.fhyyentj2qm7ti2q@thunk.org>
 <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com>
 <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com>
 <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
From: Lee Duncan <lduncan@suse.com>
Message-ID: <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
Date: Fri, 16 Jun 2017 20:45:57 -0700
MIME-Version: 1.0
In-Reply-To: <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is
 seeded before use
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/16/2017 05:41 PM, Jason A. Donenfeld wrote:
> Hi Lee,
> 
> On Fri, Jun 16, 2017 at 11:58 PM, Lee Duncan <lduncan@suse.com> wrote:
>> It seems like what you are doing is basically "good", i.e. if there is
>> not enough random data, don't use it. But what happens in that case? The
>> authentication fails? How does the user know to wait and try again?
> 
> The process just remains in interruptible (kill-able) sleep until
> there is enough entropy, so the process doesn't need to do anything.
> If the waiting is interrupted by a signal, it returns -ESYSRESTART,
> which follows the usual semantics of restartable syscalls.
> 
> Jason
> 

In your testing, how long might a process have to wait? Are we talking
seconds? Longer? What about timeouts?

Sorry, but your changing something that isn't exactly broken, so I just
want to be sure we're not introducing some regression, like clients
can't connect the first 5 minutes are a reboot.
-- 
Lee Duncan
