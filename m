Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: tomeu.vizoso@gmail.com
In-Reply-To: <CAPeXnHt+urPvRJKDmYHEAuLvkTe7mhp+0_yFD5VboQzt_-cRnA@mail.gmail.com>
References: <20170103225831.GA113525@beast> <20170104093236.GB31677@kroah.com>
 <CAPeXnHudW-YDmoK8NrFzQgAq4WuRDgFNC5-0GaG0+jVkq+3meQ@mail.gmail.com>
 <20170104194600.GC25268@kroah.com> <CAPeXnHt+urPvRJKDmYHEAuLvkTe7mhp+0_yFD5VboQzt_-cRnA@mail.gmail.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 5 Jan 2017 09:13:00 +0100
Message-ID: <CAAObsKDuqX+EgNctsXofDV8sXnArvgNMAOphgPDgsuz33wCjzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Allow userspace control of runtime disabling/enabling of
 driver probing
To: Matthew Garrett <mjg59@coreos.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Ulf Hansson <ulf.hansson@linaro.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Lukas Wunner <lukas@wunner.de>, Madalin Bucur <madalin.bucur@nxp.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Petr Tesarik <ptesarik@suse.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4 January 2017 at 20:59, Matthew Garrett <mjg59@coreos.com> wrote:
> On Wed, Jan 4, 2017 at 1:46 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Wed, Jan 04, 2017 at 12:10:04PM -0600, Matthew Garrett wrote:
>>> On Wed, Jan 4, 2017 at 3:32 AM, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>> > Turning on and off at random times "new devices can not be bound, wait,
>>> > now they can!" is ripe for loads of issues and is going to be a pain to
>>> > properly maintain over time.
>>>
>>> What kind of issues?
>>
>> How are you going to test this to ensure it continues to work properly?
>
> It's code that's already used over every suspend and resume. What kind
> of breakage are you expecting? How do we test any feature to ensure it
> continues to work properly?

In this specific case, we could use the Chamelium board to emulate USB
devices, automating the plugging of various USB device types at
different system states:

https://www.chromium.org/chromium-os/testing/chamelium

We are currently working on improving LAVA support for helper devices
such as the Chamelium, mainly for emulating displays in graphics
tests, but it can be useful for exercising other kernel ABIs such as
disable_device_probe. The goal is to have the result of these tests
reported to kernelci.org for spotting regressions early.

Regards,

Tomeu
