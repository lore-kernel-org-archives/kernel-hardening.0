Reply-To: kernel-hardening@lists.openwall.com
Sender: Jeff Garzik <jgpobox@gmail.com>
Message-ID: <4E1FE51B.70009@pobox.com>
Date: Fri, 15 Jul 2011 02:58:35 -0400
From: Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
References: <20110625170752.GA10458@albatros> <20110715063526.GB3166@albatros>
In-Reply-To: <20110715063526.GB3166@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] acpi: constify ops structs
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Len Brown <lenb@kernel.org>, kernel-hardening@lists.openwall.com, Shaohua Li <shaohua.li@intel.com>, Zhang Rui <rui.zhang@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 07/15/2011 02:35 AM, Vasiliy Kulikov wrote:
> Hi Len,
>
> On Sat, Jun 25, 2011 at 21:07 +0400, Vasiliy Kulikov wrote:
>> Structs battery_file, acpi_dock_ops, file_operations,
>> thermal_cooling_device_ops, thermal_zone_device_ops, kernel_param_ops
>> are not changed in runtime.  It is safe to make them const.
>> register_hotplug_dock_device() was altered to take const "ops" argument
>> to respect acpi_dock_ops' const notion.
>>
>> Signed-off-by: Vasiliy Kulikov<segoon@openwall.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>
