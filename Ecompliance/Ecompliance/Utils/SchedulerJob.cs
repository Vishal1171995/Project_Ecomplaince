using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Quartz;
using Quartz.Impl;
namespace Ecompliance.Utils
{
    public class SchedulerJob
    {
        public static void Start()
        {

            try
            {
                // construct a scheduler factory
                ISchedulerFactory schedFact = new StdSchedulerFactory();

                // get a scheduler
                IScheduler sched = schedFact.GetScheduler();
                sched.Start();

                IJobDetail job = JobBuilder.Create<Scheduler>()
                    .WithIdentity("myJob", "group1") // name "myJob", group "group1"
		            .Build();

                ITrigger trigger = TriggerBuilder.Create()
                    .WithIdentity("trigger3", "group1")
                    .WithCronSchedule("10 0 0,5 * * ?")
                    .ForJob("myJob", "group1") // identify job with name, group strings
                    .Build();
                sched.ScheduleJob(job, trigger);
            }
            catch(SchedulerConfigException E)
            {
                string Exp = E.Message;

            }
            catch (SchedulerException E)
            {
                string Exp1 = E.Message;

            }
        }  
    }
}